class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.1.tar.xz"
  sha256 "5d05bb38a23fd3312b10aea93840feec685bdf4a41146e78882848165d3ae921"

  keg_only :provided_until_xcode43

  depends_on "autoconf"

  def install
    ENV["PERL"] = "/usr/bin/perl" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "LN=cp\ -p", "V=1"
    system "make", "install", "LN=cp\ -p", "V=1"

    bin.cd do
      system "rm", "-f", "aclocal-1.16", "automake-1.16"
      system "ln", "-sf", "aclocal", "aclocal-1.16"
      system "ln", "-sf", "automake", "automake-1.16"
    end

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<~EOS
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<~EOS
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
