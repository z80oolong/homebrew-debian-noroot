# Module for Installing preloaded dynamic library and PRoot.
# On Debian noroot, preloaded dynamic libraries and PRoot are installed in `$HOMEBREW_PREFIX/preload`.

class ::Pathname
  PreloadDir = ::Pathname.new("#{::HOMEBREW_PREFIX}/preload")

  private

  def split_ext(path)
    base = ::Pathname.new(path).basename.to_s

    if /(^[^@]*(?:@\d+(?:\.\d+)*)?)\.?([^\.]*)$/ === base then
      return [$1, $2]
    end

    raise "Irregal path name `#{path}`"
  end

  alias :__install__ :install

  class << PreloadDir
    def install(source)
      base, ext = split_ext(source)

      system "sleep", "1"
      self.__install__ source => ("#{base}-%08x#{ext}" % [Time.now.to_i])

      ohai "Install #{source} => #{current(source)}"
    end

    def current(filename)
      base, ext = split_ext(filename)

      @current ||= Pathname.glob("#{self}/#{base}-[0-9a-f]*#{ext}").max {|f1,f2| f1.ctime <=> f2.ctime}

      return self/"#{base}-********#{ext}" unless @current
      return @current
    end
  end
end
