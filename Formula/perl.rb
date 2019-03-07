class Perl < Formula
  desc "Highly capable, feature-rich programming language"
  homepage "https://www.perl.org/"
  url "https://www.cpan.org/src/5.0/perl-5.28.0.tar.xz"
  sha256 "059b3cb69970d8c8c5964caced0335b4af34ac990c8e61f7e3f90cd1c2d11e49"
  head "https://perl5.git.perl.org/perl.git", :branch => "blead"

  option "with-dtrace", "Build with DTrace probes"

  unless OS.mac?
    depends_on "gdbm"
    depends_on "berkeley-db"

    # required for XML::Parser
    depends_on "expat"
  end

  # Prevent site_perl directories from being removed
  skip_clean "lib/perl5/site_perl"

  def install
    args = %W[
      -des
      -Dtargetarch=linux
      -Ulongdblinfbytes
      -Ulongdblnanbytes
      -Dprefix=#{prefix}
      -Dprivlib=#{lib}/perl5/#{version}
      -Dsitelib=#{lib}/perl5/site_perl/#{version}
      -Dotherlibdirs=#{HOMEBREW_PREFIX}/lib/perl5/site_perl/#{version}
      -Dperlpath=#{opt_bin}/perl
      -Dstartperl=#!#{opt_bin}/perl
      -Dman1dir=#{man1}
      -Dman3dir=#{man3}
      -Duseshrplib
      -Duselargefiles
      -Dusethreads
    ]

    args << "-Dusedtrace" if build.with? "dtrace"
    args << "-Dusedevel" if build.head?
    # Fix for https://github.com/Linuxbrew/homebrew-core/issues/405
    args << "-Dlocincpth=#{HOMEBREW_PREFIX}/include" if OS.linux?

    system "./Configure", *args

    # macOS's SIP feature prevents DYLD_LIBRARY_PATH from being passed to child
    # processes, which causes the `make test` step to fail.
    # https://rt.perl.org/Ticket/Display.html?id=126706
    # https://github.com/Homebrew/legacy-homebrew/issues/41716
    # As of perl 5.28.0 `make` fails, too, so work around it with a symlink.
    # Reported 25 Jun 2018 https://rt.perl.org/Ticket/Display.html?id=133306
    (lib/"perl5/#{version}/darwin-thread-multi-2level/CORE").install_symlink buildpath/"libperl.dylib" if OS.mac?

    # Fix config.h
    inreplace "config.h", /^#define LONGDBLINFBYTES .*/, "#undef LONGDBLINFBYTES"
    inreplace "config.h", /^#define LONGDBLNANBYTES .*/, "#undef LONGDBLNANBYTES"

    system "make"
    # On Linux (in travis / docker container), the op/getppid.t fails too, disable the tests:
    # https://rt.perl.org/Public/Bug/Display.html?id=130143
    system "make", "test" if build.bottle? && OS.mac?

    # Remove the symlink so the library actually gets installed.
    rm lib/"perl5/#{version}/darwin-thread-multi-2level/CORE/libperl.dylib" if OS.mac?

    system "make", "install"

    # expose libperl.so to ensure we aren't using a brewed executable
    # but a system library
    if OS.linux?
      perl_core = Pathname.new(`#{bin/"perl"} -MConfig -e 'print $Config{archlib}'`)+"CORE"
      lib.install_symlink perl_core/"libperl.so"
    end
  end

  def post_install
    # CPAN modules installed via the system package manager will not be visible to
    # brewed Perl. As a temporary measure, install critical CPAN modules to ensure
    # they are available. See https://github.com/Linuxbrew/homebrew-core/pull/1064
    unless OS.mac?
      ENV.activate_extensions!
      ENV.setup_build_environment(self)
      ENV["PERL_MM_USE_DEFAULT"] = "1"
      system bin/"cpan", "-i", "XML::Parser"
      system bin/"cpan", "-i", "XML::SAX"
    end
  end

  def caveats; <<~EOS
    By default non-brewed cpan modules are installed to the Cellar. If you wish
    for your modules to persist across updates we recommend using `local::lib`.

    You can set that up like this:
      PERL_MM_OPT="INSTALL_BASE=$HOME/perl5" cpan local::lib
      echo 'eval "$(perl -I$HOME/perl5/lib/perl5 -Mlocal::lib=$HOME/perl5)"' >> #{shell_profile}
  EOS
  end

  test do
    (testpath/"test.pl").write "print 'Perl is not an acronym, but JAPH is a Perl acronym!';"
    system "#{bin}/perl", "test.pl"
  end
end
