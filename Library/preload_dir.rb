# Module for Installing preloaded dynamic library and PRoot.
# On Debian noroot, preloaded dynamic libraries and PRoot are installed in `$HOMEBREW_PREFIX/preload`.

class ::Pathname
  PreloadDir = ::Pathname.new("#{::HOMEBREW_PREFIX}/preload")

  private

  def split_ext(path)
    base = ::Pathname.new(path).basename.to_s

    if /^([^@\.]*(?:@\d+(?:\.\d+)*)?)\.?([^\.]*)$/ === base then
      return [$1, $2]
    end

    raise "Irregal path name `#{path}`"
  end

  alias :__install__ :install

  class << PreloadDir
    def install(source)
      base, ext = split_ext(source)

      system "sleep", "1"
      env_ld_preload = ENV["LD_PRELOAD"]; ENV["LD_PRELOAD"] = ""

      preload_source = "#{base}-%08x.#{(ext == "") ? "bin" : ext}" % [Time.now.to_i]
      dest = (ext == "") ? "#{base}.bin" : base
      (self/dest).__install__ source => preload_source
      self.cd { FileUtils.ln_sf "./#{dest}/#{preload_source}", "#{source.basename}" }

      ENV["LD_PRELOAD"] = env_ld_preload

      ohai "Install #{source} => #{self}/#{dest}/#{preload_source}"
      ohai "Make Symbolic Link #{self}/#{dest}/#{preload_source} => #{self}/#{source.basename}"
    end
  end
end
