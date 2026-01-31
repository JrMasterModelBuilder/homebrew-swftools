class SwftoolsHead < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "https://github.com/JrMasterModelBuilder/homebrew-swftools/releases/download/sources/swftools-master-2021-12-16-772e55a271f66818b06c6e8c9b839befa51248f4.tar.gz"
  version "2021-12-16"
  sha256 "7e4394805dac36f3facf9defa21e0277e942b43b1b1ccd5f2d0e4859f63b5522"
  revision 1

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"

  conflicts_with "swftools", because: "homebrew version (missing features)"
  conflicts_with "swftools-stable", because: "stable version"
  conflicts_with "swftools-dev", because: "development snapshot"

  def install
    rm_rf "lib/lame"
    inreplace "configure", "/usr/include/fontconfig", "#{Formula["fontconfig"].opt_include}/fontconfig"
    inreplace "configure", "$CPPFLAGS -I /usr/", "$CPPFLAGS -I/usr/"
    inreplace "configure", "/usr/include/lame", "#{Formula["lame"].opt_include}/lame"
    inreplace "configure", "/usr/local/include/lame", "#{Formula["lame"].opt_include}/lame"
    ENV["PYTHON_LIB"] = "/dev/null"
    ENV["PYTHON_INCLUDES"] = "/dev/null"
    ENV["RUBY"] = "/dev/null"
    system "./configure", "--prefix=#{prefix}"
    chdir "lib/pdf" do
      system "perl", "inject-xpdf.pl", "xpdf-3.02.tar.gz"
    end
    system "make"
    system "make", "install"
    bin.install "src/ttftool"
    bin.install "src/swfbytes"
  end

  test do
    system "#{bin}/png2swf", "-z", "-o", "swftools_test_png2swf.swf", test_fixtures("test.png")
    system "#{bin}/gif2swf", "-z", "-o", "swftools_test_gif2swf.swf", test_fixtures("test.gif")
    system "#{bin}/jpeg2swf", "-z", "-o", "swftools_test_jpeg2swf.swf", test_fixtures("test.jpg")
    system "#{bin}/wav2swf", "-o", "swftools_test_wav2swf.swf", test_fixtures("test.wav")
  end
end
