$:.unshift("#{Tap.fetch("z80oolong/debian-noroot").path}")

require "lib/preload_dir"

class Proot < Formula
  desc "chroot, mount --bind, and binfmt_misc without privilege/setup"
  homepage "https://github.com/termux/proot"
  url "https://github.com/termux/proot/archive/c24fa3a43af2336a93f63fe3fb3eac599f0e3592.zip"
  version "0.4"
  sha256 "185e01d02a0bbf93036d143500e747e06b95fa6056fc1b8c1a093764b467e5b8"

  head do
    url "https://github.com/termux/proot.git"
  end

  patch do
    url "https://github.com/z80oolong/proot-termux-build/releases/download/v0.4/proot-termux-fix.diff"
    sha256 "980d69b2f04914e8b3504a4b0f2f6fbfc034b4126bc301e70b7d86f5fee5ee08"
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

    Pathname::PreloadDir.install(bin/"#{name}")

    bin.rmtree
    prefix.install "README.md" => "#{name}-#{version}.md"
  end

  def caveats; <<~EOS
    To use #{name}, modify bootstrap script file /proot.sh on Debian noroot environment:
    
    for example:
    ...
    .#{Pathname::PreloadDir.current("#{name}")} -r `pwd` -w / -b /dev -b /proc -b /sys -b /system ...
    ...
    EOS
  end
end
