class Krb5AT116 < Formula
  desc "Network authentication protocol"
  homepage "https://web.mit.edu/kerberos/"
  url "https://kerberos.org/dist/krb5/1.16/krb5-1.16.1.tar.gz"
  sha256 "214ffe394e3ad0c730564074ec44f1da119159d94281bbec541dc29168d21117"

  patch do
    url "https://raw.githubusercontent.com/z80oolong/diffs/master/krb5/krb5-1.16.1-fix.diff"
    sha256 "991f209c622645806fd9e735ee4505be187e290d387fee1908523711f177a381"
  end

  keg_only :versioned_formula

  depends_on "openssl"
  depends_on "bison"

  def install
    cd "src" do
      system "./configure",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--prefix=#{prefix}",
        "--without-system-verto"
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/krb5-config", "--version"
    assert_match include.to_s,
      shell_output("#{bin}/krb5-config --cflags")
  end
end
