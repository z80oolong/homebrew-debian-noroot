class LibandroidPty < Formula
  desc "Preloaded-dynamic library for pty function on Debian noroot."
  homepage "http://qiita.com/z80oolong/items/d3585cd5542d3d60ce12"
  url "https://github.com/z80oolong/libandroid-pty/archive/v0.1.tar.gz"
  version "0.1"
  sha256 "17bb04874d5c2779fbd95d1f28db10313c05dca78e64b249a920d0b557a6994c"

  head do
    url "https://github.com/z80oolong/libandroid-pty.git"
  end

  keg_only "dynamic library `libandroid-pty.so' is preloaded by other program." 

  def install
    gcc = ENV["HOMEBREW_CC"] || %x[which gcc].chomp
    strip = %x[which strip].chomp

    system "make", "GCC=#{gcc}", "STRIP=#{strip}"
    system "make", "install", "INSTALL_DIR=#{prefix}/lib"

    system "sleep", "1"

    Pathname.new("#{HOMEBREW_PREFIX}/lib/preload").mkpath
    preloadlib = "#{HOMEBREW_PREFIX}/lib/preload/libandroid-pty-%08x.so" % [Time.now.to_i]

    ohai "Set envionment variable LD_PRELOAD to use libandroid-pty.so:"
    ohai "  LD_PRELOAD='... #{preloadlib}'"

    system "install", "-m", "0700", "#{prefix}/lib/libandroid-pty.so", preloadlib
  end

  test do
    system "false"
  end
end
