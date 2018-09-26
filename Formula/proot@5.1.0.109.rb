$:.unshift("#{Tap.fetch("z80oolong/debian-noroot").path}")

require "lib/preload_dir"

class ProotAT510109 < Formula
  desc "chroot, mount --bind, and binfmt_misc without privilege/setup"
  homepage "https://github.com/termux/proot"
  url "https://github.com/z80oolong/proot-termux-build/releases/download/v5.1.0.109/proot-5.1.0.109.zip"
  version "5.1.0.109"
  sha256 "55c395f3f6797005feb82b22a76ea65cda5c61fe57f963bfa575e6d3403556b2"

  depends_on "z80oolong/debian-noroot/talloc@2.1.14"

  def install
    f_talloc = Formula["z80oolong/debian-noroot/talloc@2.1.14"]

    cd "src" do
      ENV.append "LC_ALL", "C"
      system "make", "-f", "./GNUmakefile", \
                           "CPPFLAGS=-D_FILE_OFFSET_BITS=64\ -D_GNU_SOURCE\ -I.\ -I#{f_talloc.opt_include}\ -I#{HOMEBREW_PREFIX}/include", \
                           "CFLAGS=-Wall\ -Wextra\ -O2", \
                           "LDFLAGS=-L#{f_talloc.opt_lib}\ -L#{HOMEBREW_PREFIX}/lib\ -static\ -ltalloc\ -Wl,-z,noexecstack", "V=1"
      system "make", "install", "PREFIX=#{prefix}"
      system "strip", "#{bin}/proot"
      system "mv", "#{bin}/proot", "#{bin}/#{name}"
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
