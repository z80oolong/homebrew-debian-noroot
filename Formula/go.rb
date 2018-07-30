class Go < Formula
  desc "Open source programming language to build simple/reliable/efficient software"
  homepage "https://golang.org"

  stable do
    url "https://dl.google.com/go/go1.10.3.src.tar.gz"
    mirror "https://fossies.org/linux/misc/go1.10.3.src.tar.gz"
    sha256 "567b1cc66c9704d1c019c50bef946272e911ec6baf244310f87f4e678be155f2"

    go_version = version.to_s.split(".")[0..1].join(".")
    resource "gotools" do
      url "https://go.googlesource.com/tools.git",
          :branch => "release-branch.go#{go_version}"
    end

    # Backports the following commit from 1.10/1.11:
    # https://github.com/golang/go/commit/1a92cdbfc10e0c66f2e015264a39159c055a5c15
    patch do
      url "https://github.com/golang/go/commit/1a92cdbfc10e0c66f2e015264a39159c055a5c15.patch?full_index=1"
      sha256 "9b879e3e759d56093ca7660305c3e4f8aee8acdd87126dc10985360395704139"
    end
  end

  head do
    url "https://go.googlesource.com/go.git"

    resource "gotools" do
      url "https://go.googlesource.com/tools.git"
    end
  end

  option "without-cgo", "Build without cgo (also disables race detector)"
  option "without-race", "Build without race detector"

  # Don't update this unless this version cannot bootstrap the new version.
  if (OS.mac? || !Hardware::CPU.is_32_bit?) then
    raise "This formula is used for Debian noroot environment. Use `brew install go`."
  end
  
  resource "gobootstrap" do
    case Hardware::CPU.arch_32_bit
    when :arm
      url "https://storage.googleapis.com/golang/go1.7.linux-armv6l.tar.gz"
      sha256 "4192592728e2f9fac8ae43abedb4b98d811836c3965035e7cb8c603aa5e65be4"
    when :intel
      url "https://storage.googleapis.com/golang/go1.7.linux-386.tar.gz"
      sha256 "1207477aa3471222f0555825f9d6ac2a39abc75839f2dfd357f19f5077f710f2"
    end
    version "1.7"
  end

  def install
    case Hardware::CPU.arch_32_bit
    when :arm
      ENV["GOHOSTARCH"] = ENV["GOARCH"] = "arm"
    when :intel
      ENV["GOHOSTARCH"] = ENV["GOARCH"] = "386"
    end

    (buildpath/"gobootstrap").install resource("gobootstrap")
    ENV["GOROOT_BOOTSTRAP"] = buildpath/"gobootstrap"

    cd "src" do
      ENV["GOROOT_FINAL"] = libexec
      ENV["GOOS"]         = OS::NAME

      ENV["CGO_ENABLED"]  = "0" if build.without?("cgo")
      system "./make.bash", "--no-clean"
    end

    (buildpath/"pkg/obj").rmtree
    rm_rf "gobootstrap" # Bootstrap not required beyond compile.
    libexec.install Dir["*"]
    bin.install_symlink Dir[libexec/"bin/go*"]

    # Build and install godoc
    ENV.prepend_path "PATH", bin
    ENV["GOPATH"] = buildpath
    (buildpath/"src/golang.org/x/tools").install resource("gotools")
    cd "src/golang.org/x/tools/cmd/godoc/" do
      system "go", "build"
      (libexec/"bin").install "godoc"
    end
    bin.install_symlink libexec/"bin/godoc"
  end

  def caveats; <<~EOS
    A valid GOPATH is required to use the `go get` command.
    If $GOPATH is not specified, $HOME/go will be used by default:
      https://golang.org/doc/code.html#GOPATH

    You may wish to add the GOROOT-based install location to your PATH:
      export PATH=$PATH:#{opt_libexec}/bin
  EOS
  end

  test do
    (testpath/"hello.go").write <<~EOS
      package main

      import "fmt"

      func main() {
          fmt.Println("Hello World")
      }
    EOS
    # Run go fmt check for no errors then run the program.
    # This is a a bare minimum of go working as it uses fmt, build, and run.
    system bin/"go", "fmt", "hello.go"
    assert_equal "Hello World\n", shell_output("#{bin}/go run hello.go")

    # godoc was installed
    assert_predicate libexec/"bin/godoc", :exist?
    assert_predicate libexec/"bin/godoc", :executable?

    if build.with? "cgo"
      ENV["GOOS"] = "freebsd"
      system bin/"go", "build", "hello.go"
    end
  end
end
