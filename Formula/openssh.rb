class Openssh < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"

  stable do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz"
    mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz"
    version "7.8p1"
    sha256 "1a484bb15152c183bb2514e112aa30dd34138c3cfb032eee5490a66c507144ca"

    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/openssh/openssh-7.8p1-fix.diff"
      sha256 "3214974e756226d3f1872d91ecfeceb11069d913a8e4bf732a1b676dbca9d670"
    end
  end

  devel do
    url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.9p1.tar.gz"
    version "7.9p1"
    sha256 "6b4b3ba2253d84ed3771c8050728d597c91cfce898713beb7b64a305b6f11aad"

    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/openssh/openssh-7.9p1-fix.diff"
      sha256 "7d8edac16e00d7cda2c8f1190a5c448ec39bc6f56b3a48a8c42f5247a8393254"
    end
  end

  head do
    url "https://anongit.mindrot.org/openssh.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build

    patch do
      url "https://raw.githubusercontent.com/z80oolong/diffs/master/openssh/openssh-HEAD-aede1c34-fix.diff"
      sha256 "79c597c86884269b81f06a7fed35af78538dc544aaf2cae156f8fae57077f1b9"
    end
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://github.com/Homebrew/homebrew-dupes/pull/482#issuecomment-118994372

  depends_on "openssl"
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"
  depends_on "daemonize" => :recommended

  unless OS.mac?
    depends_on "libedit"
    depends_on "z80oolong/debian-noroot/krb5@1.16"
    depends_on "zlib"
    depends_on "lsof" => :test
  end

  resource "com.openssh.sshd.sb" do
    url "https://opensource.apple.com/source/OpenSSH/OpenSSH-209.50.1/com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  # Both these patches are applied by Apple.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/1860b0a74/openssh/patch-sandbox-darwin.c-apple-sandbox-named-external.diff"
    sha256 "d886b98f99fd27e3157b02b5b57f3fb49f43fd33806195970d4567f12be66e71"
  end if OS.mac?

  patch do
    url "https://raw.githubusercontent.com/Homebrew/patches/d8b2d8c2/openssh/patch-sshd.c-apple-sandbox-named-external.diff"
    sha256 "3505c58bf1e584c8af92d916fe5f3f1899a6b15cc64a00ddece1dc0874b2f78f"
  end if OS.mac?

  def install
    ENV.append "CPPFLAGS", "-D__APPLE_SANDBOX_NAMED_EXTERNAL__" if OS.mac?
    ENV.append "CFLAGS", "-DDEBIAN_NOROOT"
    ENV.append "CPPFLAGS", "-DDEBIAN_NOROOT"

    system "autoreconf" if build.head?

    # Ensure sandbox profile prefix is correct.
    # We introduce this issue with patching, it's not an upstream bug.
    inreplace "sandbox-darwin.c", "@PREFIX@/share/openssh", etc/"ssh" if OS.mac?

    args = %W[
      --with-libedit
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pam" if OS.mac?
    args << "--with-privsep-path=#{var}/lib/sshd" unless OS.mac?
    args << "--with-ldns" if build.with? "ldns"

    system "./configure", *args
    system "make"
    ENV.deparallelize
    system "make", "install"

    # This was removed by upstream with very little announcement and has
    # potential to break scripts, so recreate it for now.
    # Debian have done the same thing.
    bin.install_symlink bin/"ssh" => "slogin"

    buildpath.install resource("com.openssh.sshd.sb")
    (etc/"ssh").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"
  end

  def post_install
    unless (etc/"ssh/openssh.d").exist?
      ohai "Create #{etc}/ssh/openssh.d ..."

      (etc/"ssh/openssh.d").atomic_write(<<~EOS)
        #!#{ENV['SHELL']}

        OPENSSH=#{opt_sbin}/sshd
        SERVER_OPTION="-f #{etc}/ssh/sshd_config"
        PID_FILE=/var/run/openssh.pid
        LOG_FILE=/var/log/openssh.log
        LOCK_FILE=/var/run/openssh.lock

        start_daemon () {
      		echo "Start Dropbear Daemon..."
        	export PATH=#{HOMEBREW_PREFIX}/sbin:#{HOMEBREW_PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        	#{%x[which daemonize].chomp} -a -p $PID_FILE -l $LOCK_FILE -e $LOG_FILE -o $LOG_FILE -v $OPENSSH $SERVER_OPTION -E $LOG_FILE
        }

        stop_daemon () {
        	if [ -e $LOCK_FILE ]; then
        		echo "Stop Dropbear Daemon..."
        		kill -TERM `cat $PID_FILE`; rm -f $LOCK_FILE
        	fi
        }

        if [ "x$1" = "xstop" ]; then
        	stop_daemon
        	exit 0
        elif [ "x$1" = "xstart" ]; then
        	stop_daemon
        	start_daemon
        	exit 0
        else
        	echo "Usage: $0 {start|stop}"
        	exit 255
        fi
        EOS
      (etc/"ssh/openssh.d").chmod(0700)
    end
  end

  test do
    assert_match "OpenSSH_", shell_output("#{bin}/ssh -V 2>&1")

    begin
      pid = fork { exec sbin/"sshd", "-D", "-p", "8022" }
      sleep 2
      assert_match "sshd", shell_output("lsof -i :8022")
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end