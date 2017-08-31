class Proot < Formula
  desc "chroot, mount --bind, and binfmt_misc without privilege/setup"
  homepage "https://github.com/termux/proot"
  url "https://github.com/termux/proot/archive/edc869d60c7f5b6abf67052a327ef099aded7777.zip"
  version "5.1.0-gedc869d6"
  sha256 "3b1a579a108c17e897ef8da02ed7af8d77000c5d9946ed72f113f87ce61f5637"

  head do
    url "https://github.com/termux/proot.git"
  end

  depends_on "z80oolong/debian-noroot/talloc"

  def install
    f_talloc = Formula["z80oolong/debian-noroot/talloc"]

    cd "src" do
      ENV.append "LC_ALL", "C"
      system "make", "-f", "./GNUmakefile", \
                           "CPPFLAGS=-D_FILE_OFFSET_BITS=64\ -D_GNU_SOURCE\ -I.\ -I#{f_talloc.include}\ -I#{HOMEBREW_PREFIX}/include", \
                           "CFLAGS=-Wall\ -Wextra\ -O2", \
                           "LDFLAGS=-L#{f_talloc.lib}\ -L#{HOMEBREW_PREFIX}/lib\ -static\ -ltalloc\ -Wl,-z,noexecstack", "V=1"
      system "make", "install", "PREFIX=#{prefix}"
      system "strip", "#{bin}/proot"
    end

    system "sleep", "1"

    Pathname.new("#{HOMEBREW_PREFIX}/xbin").mkpath
    prootbin = "#{HOMEBREW_PREFIX}/xbin/#{name}-%08x" % [Time.now.to_i]

    ohai "On Debian noroot environment, modify /proot.sh:"
    ohai "  ..."
    ohai "  .#{prootbin} -r `pwd` -w / -b /dev -b /proc -b /sys -b /system ..."

    system "install", "-m", "0700", "#{prefix}/bin/#{name}", prootbin
  end

  test do
    system "false"
  end
end
