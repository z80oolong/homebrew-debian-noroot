require Tap.fetch("z80oolong/debian-noroot").path/"lib/install_preload.rb"

class Proot < Formula
  desc "chroot, mount --bind, and binfmt_misc without privilege/setup"
  homepage "https://github.com/termux/proot"
  url "https://github.com/termux/proot/archive/454b0b121f03a662f53844a8865f518757e0a315.zip"
  version "5.1.0-gedc869d6"
  sha256 "571a56af65969dbb26096893c32a5121e5cb3acd8d5fb6de8130765579bd2eb0"

  head do
    url "https://github.com/termux/proot.git"
  end

  patch do
    url "https://github.com/z80oolong/proot-termux-build/releases/download/v0.3/proot-termux-fix.diff"
    sha256 "980d69b2f04914e8b3504a4b0f2f6fbfc034b4126bc301e70b7d86f5fee5ee08"
  end

  depends_on "z80oolong/debian-noroot/talloc"

  conflicts_with "z80oolong/ext/proot", :because => "`z80oolong/ext/proot` is installed for non-Debian noroot environment."

  def preload_dir
    @preload_dir ||= ::Pathname.new("#{HOMEBREW_PREFIX}/preload")
    @preload_dir.mkpath unless @preload_dir.directory?
    return @preload_dir
  end
  private :preload_dir

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

    preload_dir.install_preload_dir(bin/"#{name}")
  end

  def caveats; <<-EOS.undent
    To use #{name}, modify bootstrap script file /proot.sh on Debian noroot environment:
    
    for example:
    ...
    .#{preload_dir.current_file("#{name}")} -r `pwd` -w / -b /dev -b /proc -b /sys -b /system ...
    ...
    EOS
  end
end
