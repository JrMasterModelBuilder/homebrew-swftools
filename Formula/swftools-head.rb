class SwftoolsHead < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  head "https://github.com/matthiaskramm/swftools.git"

  conflicts_with "swftools", because: "Homebrew version (missing features)"
  conflicts_with "swftools-stable", because: "Stable version"
  conflicts_with "swftools-dev", because: "Development snapshot"

  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "fontconfig"

  def install
    inreplace "lib/as3/registry.h" do |s|
      s.gsub! /^classinfo_t voidclass;/, "// classinfo_t voidclass;"
    end
    inreplace "configure", "/usr/include/fontconfig", "#{Formula['fontconfig'].opt_include}/fontconfig"
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
    system "#{bin}/png2swf", "-z", "swftools_test_png2swf.swf", test_fixtures("test.png")
    system "#{bin}/gif2swf", "-z", "swftools_test_gif2swf.swf", test_fixtures("test.gif")
    system "#{bin}/jpeg2swf", "-z", "swftools_test_jpeg2swf.swf", test_fixtures("test.jpg")
    system "#{bin}/wav2swf", "swftools_test_wav2swf.swf", test_fixtures("test.wav")
  end
end
