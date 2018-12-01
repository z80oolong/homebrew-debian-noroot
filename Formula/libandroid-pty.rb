class LibandroidPty < Formula
  desc "Preloaded dynamic library for pseudo terminal function on Debian noroot."
  homepage "http://qiita.com/z80oolong/items/d3585cd5542d3d60ce12"
  url "https://github.com/z80oolong/libandroid-pty/archive/v0.1.1.tar.gz"
  version "0.1.1"
  sha256 "1cd7c8d59923de379d398c8e60dfb8629f9e8518d6ba9b42b2239851d638c6c7"

  head do
    url "https://github.com/z80oolong/libandroid-pty.git"
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

    system "make", "GCC=#{gcc}", "STRIP=#{strip}", "LIBANDROID_PTY_SO=#{name}.so"
    system "make", "install", "INSTALL_PREFIX=#{prefix}"
    
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
