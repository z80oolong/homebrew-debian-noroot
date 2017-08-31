class LibandroidPty < Formula
  desc "Preloaded-dynamic library for pseudo terminal function on Debian noroot."
  homepage "http://qiita.com/z80oolong/items/d3585cd5542d3d60ce12"
  url "https://github.com/z80oolong/libandroid-pty/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "1cd7c8d59923de379d398c8e60dfb8629f9e8518d6ba9b42b2239851d638c6c7"

  head do
    url "https://github.com/z80oolong/libandroid-pty.git"
  end

  def install
    gcc = ENV.cc || %x[which gcc].chomp
    strip = %x[which strip].chomp

    system "make", "GCC=#{gcc}", "STRIP=#{strip}", "LIBANDROID_PTY_SO=#{name}.so"
    system "make", "install", "INSTALL_PREFIX=#{prefix}"

    system "sleep", "1"

    preloadlib = Pathname.new("#{HOMEBREW_PREFIX}/lib/preload"); preloadlib.mkpath
    preload_so = "#{name}-%08x.so" % [Time.now.to_i]

    ohai "Set envionment variable LD_PRELOAD to use #{name}.so:"
    ohai "/usr/bin/env LD_PRELOAD='... #{preloadlib}/#{preload_so}'"

    preloadlib.install "#{name}.so" => preload_so
  end
end
