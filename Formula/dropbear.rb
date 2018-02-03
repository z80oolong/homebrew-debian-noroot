class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2017.75.tar.bz2"
  mirror "https://dropbear.nl/mirror/dropbear-2017.75.tar.bz2"
  sha256 "6cbc1dcb1c9709d226dff669e5604172a18cf5dbf9a201474d5618ae4465098c"

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  if build.head? then
    patch do
      url "https://gist.githubusercontent.com/z80oolong/3e353bd8f0b44f415880d047b4dad4af/raw/1711a06e29772b6c4173ed75fa4b80fb663eb789/dropbear-HEAD-8ffa8f72.diff"
      sha256 "b4371b4f453b3cf8fdc1c17f4e15d17054cf0c05268ac67cd259b0fe3de22c02"
    end
  else
    patch do
      url "https://gist.githubusercontent.com/z80oolong/3e353bd8f0b44f415880d047b4dad4af/raw/0f8c18fd98e72ca9009d041e015c4d393e12a317/dropbear-2017.75-fix.diff"
      sha256 "25a77a049dc2f604158bc38d6c0dda71f3ec11d2e238e1226b69a7500c599dc9"    
    end
  end

  depends_on "daemonize" => :recommended

  def install
    if build.head?
      system "autoconf"
      system "autoheader"
    end

    ENV.append "CFLAGS", "-DDEBIAN_NOROOT -DDEBUG_TRACE"
    ENV.append "CFLAGS", %{-DDSS_PRIV_FILENAME=\\"#{etc}/dropbear/dropbear_dss_host_key\\"}
    ENV.append "CFLAGS", %{-DRSA_PRIV_FILENAME=\\"#{etc}/dropbear/dropbear_rsa_host_key\\"}
    ENV.append "CFLAGS", %{-DECDSA_PRIV_FILENAME=\\"#{etc}/dropbear/dropbear_ecdsa_host_key\\"}

    system "./configure", "--prefix=#{prefix}",
                          "--disable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end
  
  def post_install
    unless (etc/"dropbear").exist? && (etc/"dropbear").directory?
      ohai "Make directory #{etc}/dropbear ..."
      (etc/"dropbear").mkdir
    end

    unless (etc/"dropbear/dropbear.d").exist?
      ohai "Create #{etc}/dropbear/dropbear.d ..."

      (etc/"dropbear/dropbear.d").atomic_write(<<~EOS)
        #!#{ENV['SHELL']}

        DROPBEAR=#{opt_sbin}/dropbear
        PORT=12022
        SERVER_OPTION="-W 65536 -s -w -g"
        DSS_HOST_KEY=#{etc}/dropbear/dropbear_dss_host_key
        RSA_HOST_KEY=#{etc}/dropbear/dropbear_rsa_host_key
        ECDSA_HOST_KEY=#{etc}/dropbear/dropbear_ecdsa_host_key
        PID_FILE=/var/run/dropbear.pid
        LOG_FILE=/var/log/dropbear.log
        LOCK_FILE=/var/run/dropbear.lock

        start_daemon () {
      		echo "Start Dropbear Daemon..."
        	export PATH=#{HOMEBREW_PREFIX}/sbin:#{HOMEBREW_PREFIX}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        	#{%x[which daemonize].chomp} -a -p $PID_FILE -l $LOCK_FILE -e $LOG_FILE -o $LOG_FILE -v $DROPBEAR -p $PORT -d $DSS_HOST_KEY -r $RSA_HOST_KEY -r $ECDSA_HOST_KEY $SERVER_OPTION -F -E
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
      (etc/"dropbear/dropbear.d").chmod(0700)
    end

    unless (etc/"dropbear/dropbear_dss_host_key").exist?
      ohai "Make #{etc}/dropbear/dropbear_dss_host_key ..."
      system "#{bin}/dropbearkey", "-t", "dss", "-f", "#{etc}/dropbear/dropbear_dss_host_key"
    end

    unless (etc/"dropbear/dropbear_rsa_host_key").exist?
      ohai "Make #{etc}/dropbear/dropbear_rsa_host_key ..."
      system "#{bin}/dropbearkey", "-t", "rsa", "-f", "#{etc}/dropbear/dropbear_rsa_host_key"
    end

    unless (etc/"dropbear/dropbear_ecdsa_host_key").exist?
      ohai "Make #{etc}/dropbear/dropbear_ecdsa_host_key ..."
      system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", "#{etc}/dropbear/dropbear_ecdsa_host_key"
    end
  end

  def caveats; <<~EOS
    Script to start or stop dropbear daemon has been install to:
      #{etc}/dropbear/dropbear.d

    To start dropbear daemon:
      #{etc}/dropbear/dropbear.d start

    To stop dropbear daemon:
      #{etc}/dropbear/dropbear.d stop
    EOS
  end      
      
  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert testfile.exist?
  end
end
