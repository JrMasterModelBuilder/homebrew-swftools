class SwftoolsHead < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  head "https://github.com/matthiaskramm/swftools.git"

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
