$:.unshift("#{Tap.fetch("z80oolong/debian-noroot").path}")

require "lib/preload_dir"

class LibandroidShmem < Formula
  desc "libandroid-shmem.so by Termux developer team on Debian noroot"
  homepage "https://gist.github.com/z80oolong/247dbbb0a7d83a1dea98de2939327432"
  url "https://github.com/termux/libandroid-shmem/archive/v0.2.tar.gz"
  version "0.2"
  revision 1
  sha256 "75e687f48c01d96ea1345f11c064ff76f7eb9a119f51ebe2f6253cf8b24a2b97"

  head do
    url "https://github.com/termux/libandroid-shmem.git"
  end

  patch do
    url "https://raw.githubusercontent.com/z80oolong/diffs/master/libandroid-shmem/libandroid-shmem-termux-0.2_1-fix.diff"
    sha256 "cf3409ce8ef642e72a00e51c80e6993db3d4fe2886d19dff013ae350055236fc"
  end

  def install
    gcc = ENV.cc || %x[which gcc].chomp
    strip = %x[which strip].chomp

    system "make", "CC=#{gcc}", "STRIP=#{strip}", "LIBANDROID_SHMEM_SO=#{name}.so"
    system "make", "install", "PREFIX=#{prefix}", "LIBANDROID_SHMEM_SO=#{name}.so"

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
