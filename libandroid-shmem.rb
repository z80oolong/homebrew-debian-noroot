eval (Tap.fetch("z80oolong/debian-noroot").formula_dir/"lib/install_preload_so.rb").read

class LibandroidShmem < Formula
  include InstallPreloadSO

  desc "libandroid-shmem.so by Termux developer team on Debian noroot"
  homepage "https://gist.github.com/z80oolong/247dbbb0a7d83a1dea98de2939327432"
  url "https://github.com/termux/libandroid-shmem/archive/v0.2.tar.gz"
  version "0.2"
  sha256 "75e687f48c01d96ea1345f11c064ff76f7eb9a119f51ebe2f6253cf8b24a2b97"

  head do
    url "https://github.com/termux/libandroid-shmem.git"
  end

  patch do
    url "https://gist.githubusercontent.com/z80oolong/247dbbb0a7d83a1dea98de2939327432/raw/36b2bd0bf29faf0c43dbcfbedde5d8b48a92aaf3/libandroid-shmem-termux-0.2_1-fix.diff"
    sha256 "cf3409ce8ef642e72a00e51c80e6993db3d4fe2886d19dff013ae350055236fc"
  end

  def install
    gcc = ENV.cc || %x[which gcc].chomp
    strip = %x[which strip].chomp

    system "make", "CC=#{gcc}", "STRIP=#{strip}", "LIBANDROID_SHMEM_SO=#{name}.so"
    system "make", "install", "PREFIX=#{prefix}"

    install_preload_so
  end
end
