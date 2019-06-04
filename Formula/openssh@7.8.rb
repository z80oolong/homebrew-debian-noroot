class OpensshAT78 < Formula
  desc "OpenBSD freely-licensed SSH connectivity tools"
  homepage "https://www.openssh.com/"
  url "https://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz"
  mirror "https://mirror.vdms.io/pub/OpenBSD/OpenSSH/portable/openssh-7.8p1.tar.gz"
  version "7.8p1"
  revision 1
  sha256 "1a484bb15152c183bb2514e112aa30dd34138c3cfb032eee5490a66c507144ca"

  keg_only :versioned_formula

  patch do
    url "https://raw.githubusercontent.com/z80oolong/openssh-debian-noroot-fix/master/openssh-7.8p1_1-fix.diff"
    sha256 "b336fd3bdf5400488860cab23e8a33932f66ecf58b7de04e5016fbe800884b9f"
  end

  # Please don't resubmit the keychain patch option. It will never be accepted.
  # https://github.com/Homebrew/homebrew-dupes/pull/482#issuecomment-118994372

  depends_on "openssl"
  depends_on "ldns" => :optional
  depends_on "pkg-config" => :build if build.with? "ldns"
  depends_on "krb5"
  depends_on "libedit"
  depends_on "zlib"
  depends_on "lsof" => :test
  depends_on "daemonize" => :recommended

  resource "com.openssh.sshd.sb" do
    url "https://opensource.apple.com/source/OpenSSH/OpenSSH-209.50.1/com.openssh.sshd.sb"
    sha256 "a273f86360ea5da3910cfa4c118be931d10904267605cdd4b2055ced3a829774"
  end

  def install
    ENV.append "CFLAGS", "-DDEBIAN_NOROOT"
    ENV.append "CPPFLAGS", "-DDEBIAN_NOROOT"

    system "autoreconf" if build.head?

    args = %W[
      --with-libedit
      --with-kerberos5
      --prefix=#{prefix}
      --sysconfdir=#{etc}/ssh@#{version}
      --with-ssl-dir=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-privsep-path=#{var}/lib/sshd"
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
    (etc/"ssh@#{version}").install "com.openssh.sshd.sb" => "org.openssh.sshd.sb"
  end

  def post_install
    unless (etc/"ssh@#{version}/openssh.d").exist?
      ohai "Create #{etc}/ssh@#{version}/openssh.d ..."

      (etc/"ssh@#{version}/openssh.d").atomic_write(<<~EOS)
        #!#{ENV['SHELL']}

        OPENSSH=#{opt_sbin}/sshd
        SERVER_OPTION="-f #{etc}/ssh@#{version}/sshd_config"
        PID_FILE=/var/run/openssh.pid
        LOG_FILE=/var/log/openssh.log
        LOCK_FILE=/var/run/openssh.lock

        start_daemon () {
      		echo "Start OpenSSH Daemon..."
        	export PATH=#{HOMEBREW_PREFIX}/sbin:#{HOMEBREW_PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        	#{%x[which daemonize].chomp} -a -p $PID_FILE -l $LOCK_FILE -e $LOG_FILE -o $LOG_FILE -v $OPENSSH $SERVER_OPTION -E $LOG_FILE
        }

        stop_daemon () {
        	if [ -e $LOCK_FILE ]; then
        		echo "Stop OpenSSH Daemon..."
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
      (etc/"ssh@#{version}/openssh.d").chmod(0700)
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
