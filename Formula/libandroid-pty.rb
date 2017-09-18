require Tap.fetch("z80oolong/debian-noroot").path/"lib/install_preload.rb"

class LibandroidPty < Formula
  include InstallPreloadSO

  desc "Preloaded dynamic library for pseudo terminal function on Debian noroot."
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
    
    preload_dir.install_preload_dir("#{name}.so")
  end
end
