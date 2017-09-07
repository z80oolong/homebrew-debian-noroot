# Module for Installing preloaded dynamic library and PRoot.
# On Debian noroot, preloaded dynamic libraries and PRoot are installed in `$HOMEBREW_PREFIX/boot`.

class ::Pathname
  def split_ext(filename)
    filename = ::Pathname.new(filename)
    base = filename.basename(".*"); ext = filename.extname

    return [base, ext]
  end
  private :split_ext

  def current_file(filename)
    base, ext = split_ext(filename)

    @current_file ||= Pathname.glob("#{self}/#{base}-[0-9a-f]*#{ext}").max {|f1,f2| f1.ctime <=> f2.ctime}

    return self/"#{base}-xxxxxxxxx#{ext}" unless @current_file
    return @current_file
  end

  def install_preload_dir(filename)
    base, ext = split_ext(filename)

    system "sleep", "1"
    self.install filename => ("#{base}-%08x#{ext}" % [Time.now.to_i])

    ohai "Install #{filename} => #{current_file(filename)}"
  end  
end

module InstallPreloadSO
  def preload_dir(path = "#{HOMEBREW_PREFIX}/boot")
    @preload_dir ||= ::Pathname.new(path)
    @preload_dir.mkpath unless @preload_dir.directory?
    return @preload_dir
  end
  private :preload_dir

  def caveats
    current_file = preload_dir.current_file("#{name}.so")
    ; <<-EOS.undent
    To use a preloaded dynamic library `#{name}.so`, set environment variable LD_PRELOAD to `#{current_file}`:

    for example:    
    $ export LD_PRELOAD="... #{current_file}"
    or
    $ /usr/bin/env LD_PRELOAD="... #{current_file}" linux_command
    EOS
  end
end
