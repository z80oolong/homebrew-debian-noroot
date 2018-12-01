class LibandroidShmem < Formula
  desc "libandroid-shmem.so by Termux developer team on Debian noroot"
  homepage "https://gist.github.com/z80oolong/247dbbb0a7d83a1dea98de2939327432"
  url "https://github.com/termux/libandroid-shmem/archive/v0.2.tar.gz"
  version "0.2"
  revision 2
  sha256 "75e687f48c01d96ea1345f11c064ff76f7eb9a119f51ebe2f6253cf8b24a2b97"

  head do
    url "https://github.com/termux/libandroid-shmem.git"
  end

  patch do
    url "https://raw.githubusercontent.com/z80oolong/diffs/master/libandroid-shmem/libandroid-shmem-termux-0.2_2-fix.diff"
    sha256 "7f2d18e35bd1aa51053eff36005e4d22a3ec4ee9d17bf1d11592020bd2f29008"
  end

  private

  def preload_dir
    @preload_dir ||= Pathname.new("#{HOMEBREW_PREFIX}/preload")
    return @preload_dir
  end

  def install_preload(source)
    system "sleep", "1"
    env_ld_preload = ENV["LD_PRELOAD"]; ENV["LD_PRELOAD"] = ""

    preload_dest = "#{name}-%08x.so" % [Time.now.to_i]
    (preload_dir/"#{name}").install source => preload_dest
    preload_dir.cd { FileUtils.ln_sf "./#{name}/#{preload_dest}", "./#{source.basename}" }

    ENV["LD_PRELOAD"] = env_ld_preload
    ohai "Install #{source} => #{preload_dir}/#{name}/#{preload_dest}"
    ohai "Make Symbolic Link #{preload_dir}/#{name}/#{preload_dest} => #{preload_dir}/#{source.basename}"
  end

  public

  def install
    gcc = ENV.cc || %x[which gcc].chomp
    strip = %x[which strip].chomp

    system "make", "CC=#{gcc}", "STRIP=#{strip}", "LIBANDROID_SHMEM_SO=#{name}.so"
    system "make", "install", "PREFIX=#{prefix}", "LIBANDROID_SHMEM_SO=#{name}.so"

    install_preload lib/"#{name}.so"

    lib.rmtree; include.rmtree
    prefix.install "README.md" => "#{name}-#{version}.md"
  end
  
  def caveats; <<~EOS
    To use a preloaded dynamic library `#{name}.so`, set environment variable LD_PRELOAD to `#{preload_dir}/#{name}.so`:

    for example:    
    $ export LD_PRELOAD="... #{preload_dir}/#{name}.so"
    or
    $ /usr/bin/env LD_PRELOAD="... #{preload_dir}/#{name}.so" linux_command
    EOS
  end
end
