class DropbearAT201876 < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2018.76.tar.bz2"
  mirror "https://dropbear.nl/mirror/dropbear-2018.76.tar.bz2"
  sha256 "f2fb9167eca8cf93456a5fc1d4faf709902a3ab70dd44e352f3acbc3ffdaea65"

  keg_only :versioned_formula

  patch do
    url "raw.githubusercontent.com/z80oolong/dropbear-debian-noroot-fix/master/dropbear-2018.76-fix.diff"
    sha256 "4cc496af7a1ac522cfe37f6352b8f12ced33af9910b444bded8488827d3c0019"
  end

  depends_on "daemonize" => :recommended

  def install
    ENV.append "CFLAGS", "-DDEBIAN_NOROOT -DDEBUG_TRACE"
    ENV.append "CFLAGS", %{-DDSS_PRIV_FILENAME=\\"#{etc}/#{name}/dropbear_dss_host_key\\"}
    ENV.append "CFLAGS", %{-DRSA_PRIV_FILENAME=\\"#{etc}/#{name}/dropbear_rsa_host_key\\"}
    ENV.append "CFLAGS", %{-DECDSA_PRIV_FILENAME=\\"#{etc}/#{name}/dropbear_ecdsa_host_key\\"}

    system "./configure", "--prefix=#{prefix}",
                          "--disable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/#{name}"
    system "make"
    system "make", "install"
  end
  
  def post_install
    unless (etc/"#{name}").exist? && (etc/"#{name}").directory?
      ohai "Make directory #{etc}/#{name} ..."
      (etc/"#{name}").mkdir
    end

    unless (etc/"#{name}/dropbear.d").exist?
      ohai "Create #{etc}/#{name}/dropbear.d ..."

      (etc/"#{name}/dropbear.d").atomic_write(<<~EOS)
        #!#{ENV['SHELL']}

        DROPBEAR=#{opt_sbin}/dropbear
        PORT=12022
        SERVER_OPTION="-W 65536 -s -w -g"
        DSS_HOST_KEY=#{etc}/#{name}/dropbear_dss_host_key
        RSA_HOST_KEY=#{etc}/#{name}/dropbear_rsa_host_key
        ECDSA_HOST_KEY=#{etc}/#{name}/dropbear_ecdsa_host_key
        PID_FILE=/var/run/#{name}.pid
        LOG_FILE=/var/log/#{name}.log
        LOCK_FILE=/var/run/#{name}.lock

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
      (etc/"#{name}/dropbear.d").chmod(0700)
    end

    unless (etc/"#{name}/dropbear_dss_host_key").exist?
      ohai "Make #{etc}/#{name}/dropbear_dss_host_key ..."
      system "#{bin}/dropbearkey", "-t", "dss", "-f", "#{etc}/#{name}/dropbear_dss_host_key"
    end

    unless (etc/"#{name}/dropbear_rsa_host_key").exist?
      ohai "Make #{etc}/#{name}/dropbear_rsa_host_key ..."
      system "#{bin}/dropbearkey", "-t", "rsa", "-f", "#{etc}/#{name}/dropbear_rsa_host_key"
    end

    unless (etc/"#{name}/dropbear_ecdsa_host_key").exist?
      ohai "Make #{etc}/#{name}/dropbear_ecdsa_host_key ..."
      system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", "#{etc}/#{name}/dropbear_ecdsa_host_key"
    end
  end

  def caveats; <<~EOS
    Script to start or stop dropbear daemon has been install to:
      #{etc}/#{name}/dropbear.d

    To start dropbear daemon:
      #{etc}/#{name}/dropbear.d start

    To stop dropbear daemon:
      #{etc}/#{name}/dropbear.d stop
    EOS
  end      
      
  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert testfile.exist?
  end
end
