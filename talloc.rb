class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.10.tar.gz"
  mirror "https://sources.voidlinux.eu/talloc-2.1.10/talloc-2.1.10.tar.gz"
  sha256 "c985e94bebd6ec2f6af3d95dcc3fcb192a2ddb7781a021d70ee899e26221f619"

  def install
    ENV.append "CFLAGS", "-I#{include} -I#{HOMEBREW_PREFIX}/include"
    ENV.append "LDFLAGS", "-L#{lib} -L#{HOMEBREW_PREFIX}/lib"
    ENV.append "CPPFLAGS", "-I#{include} -I#{HOMEBREW_PREFIX}/include"

    system "./configure", "--prefix=#{prefix}", "--disable-rpath", \
                          "--without-gettext", "--disable-python"
    system "make", "install", "V=1"
    cd "./bin/default" do
      system "ar", "rsuv", "./libtalloc.a", "./talloc_5.o", \
                           "./lib/replace/replace_2.o", "./lib/replace/cwrap_2.o", \
                           "./lib/replace/closefrom_2.o"
      lib.install "./libtalloc.a"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <talloc.h>
      int main()
      {
        int ret;
        TALLOC_CTX *tmp_ctx = talloc_new(NULL);
        if (tmp_ctx == NULL) {
          ret = 1;
          goto done;
        }
        ret = 0;
      done:
        talloc_free(tmp_ctx);
        return ret;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "test.c", "-o", "test", "-ltalloc"
    system testpath/"test"
  end
end
