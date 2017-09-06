eval (Tap.fetch("z80oolong/debian-noroot").formula_dir/"lib/install_preload_so.rb").read

class LibandroidShmem < Formula
  include InstallPreloadSO

  desc "libandroid-shmem.so on Termux"
  homepage "http://zool.jpn.org/"
  url "https://github.com/termux/libandroid-shmem/archive/v0.2.tar.gz"
  version "0.2"
  sha256 "75e687f48c01d96ea1345f11c064ff76f7eb9a119f51ebe2f6253cf8b24a2b97"

  head do
    url "https://github.com/termux/libandroid-shmem.git"
  end

  patch do
    url "https://gist.githubusercontent.com/z80oolong/247dbbb0a7d83a1dea98de2939327432/raw/da08c875c5dba1d5fd42745031998aa54624fa24/libandroid-shmem-termux-0.2-fix.diff"
    sha256 "ede3f814b09d3151a4702d0890f52898c1339aafb9db49f034af59bf811ae1b4"
  end

  def install
    gcc = ENV.cc || %x[which gcc].chomp
    strip = %x[which strip].chomp

    system "make", "CC=#{gcc}", "STRIP=#{strip}", "LIBANDROID_SHMEM_SO=#{name}.so"
    system "make", "install", "PREFIX=#{prefix}"

    install_preload_so
  end
end
