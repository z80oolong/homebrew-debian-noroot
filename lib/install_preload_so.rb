# Module for Installing preloaded dynamic library.
# On Debian noroot, preloaded dynamic libraries are installed in `$HOMEBREW_PREFIX/boot`.

module InstallPreloadSO
  def boot
    @boot ||= Pathname.new("#{HOMEBREW_PREFIX}/boot")
    @boot.mkpath if @boot.directory?
    return @boot
  end
  private :boot

  def current_so
    @current_so ||= Pathname.glob("#{boot}/#{name}-[0-9a-f]*.so").max {|f1,f2| f1.ctime <=> f2.ctime}
    return boot/"#{name}-xxxxxxxx.so" unless @current_so
    return @current_so
  end
  private :current_so

  def install_preload_so
    system "sleep", "1"
    boot.install "#{name}.so" => ("#{name}-%08x.so" % [Time.now.to_i])
    
    ohai "Installed `#{name}.so` => `#{current_so}`"
  end

  def caveats; <<-EOS.undent
    To use a preloaded dynamic library `#{name}.so`, set environment variable LD_PRELOAD to `#{current_so}`:

    for example:    
    $ export LD_PRELOAD="... #{current_so}"
    or
    $ /usr/bin/env LD_PRELOAD="... #{current_so}" linux_command
    EOS
  end
end
