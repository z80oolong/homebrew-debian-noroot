$:.unshift("#{Tap.fetch("z80oolong/debian-noroot").path}")

require "lib/preload_dir"

class LibandroidPty < Formula
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
    
    Pathname::PreloadDir.install(lib/"#{name}.so")

    lib.rmtree; include.rmtree
    prefix.install "README.md" => "#{name}-#{version}.md"
  end
  
  def caveats
    current_file = Pathname::PreloadDir.current("#{name}.so")
    ; <<~EOS
    To use a preloaded dynamic library `#{name}.so`, set environment variable LD_PRELOAD to `#{current_file}`:

    for example:    
    $ export LD_PRELOAD="... #{current_file}"
    or
    $ /usr/bin/env LD_PRELOAD="... #{current_file}" linux_command
    EOS
  end
end
