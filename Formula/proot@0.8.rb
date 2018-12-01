class ProotAT08 < Formula
  desc "chroot, mount --bind, and binfmt_misc without privilege/setup"
  homepage "https://github.com/termux/proot"
  url "https://github.com/termux/proot/archive/e0569ad9f64a4eb79117759c73d02251746631a0.zip"
  version "0.8"
  sha256 "4c646c27e177857e592a0e63979ac14dab95b1a2975a8b25fd3339b8375e1e2d"

  patch do
    url "https://github.com/z80oolong/proot-termux-build/releases/download/v0.8/proot-termux-fix.diff"
    sha256 "a86fc31fc86c4dd8ba09036592225bde4831ad38c02749ee63464a857c870b54"
  end

  depends_on "z80oolong/debian-noroot/talloc@2.1.14"

  private

  def preload_dir
    @preload_dir ||= Pathname.new("#{HOMEBREW_PREFIX}/preload")
    return @preload_dir
  end

  def install_preload(source)
    system "sleep", "1"
    env_ld_preload = ENV["LD_PRELOAD"]; ENV["LD_PRELOAD"] = ""

    preload_dest = "#{name}-%08x.bin" % [Time.now.to_i]
    (preload_dir/"#{name}.bin").install source => preload_dest
    preload_dir.cd { FileUtils.ln_sf "./#{name}.bin/#{preload_dest}", "./#{source.basename}" }

    ENV["LD_PRELOAD"] = env_ld_preload
    ohai "Install #{source} => #{preload_dir}/#{name}.bin/#{preload_dest}"
    ohai "Make Symbolic Link #{preload_dir}/#{name}.bin/#{preload_dest} => #{preload_dir}/#{source.basename}"
  end

  public

  def install
    f_talloc = Formula["z80oolong/debian-noroot/talloc@2.1.14"]

    cd "src" do
      ENV.append "LC_ALL", "C"
      system "make", "-f", "./GNUmakefile", \
                           "CPPFLAGS=-D_FILE_OFFSET_BITS=64\ -D_GNU_SOURCE\ -I.\ -I#{f_talloc.opt_include}\ -I#{HOMEBREW_PREFIX}/include", \
                           "CFLAGS=-Wall\ -Wextra\ -O2", \
                           "LDFLAGS=-L#{f_talloc.opt_lib}\ -L#{HOMEBREW_PREFIX}/lib\ -static\ -ltalloc\ -Wl,-z,noexecstack", "V=1"
      system "make", "install", "PREFIX=#{prefix}"
      system "strip", "#{bin}/proot"
      system "mv", "#{bin}/proot", "#{bin}/#{name}"
    end

    install_preload bin/"#{name}"

    bin.rmtree
    prefix.install "README.md" => "#{name}-#{version}.md"
  end

  def caveats; <<~EOS
    To use #{name}, modify bootstrap script file /proot.sh on Debian noroot environment:
    
    for example:
    ...
    .#{preload_dir}/#{name} -r `pwd` -w / -b /dev -b /proc -b /sys -b /system ...
    ...
    EOS
  end
end
