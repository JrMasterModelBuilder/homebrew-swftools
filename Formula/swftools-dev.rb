class SwftoolsDev < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "http://www.swftools.org/swftools-2013-04-09-1007.tar.gz"
  version "2013-04-09-1007"
  sha256 "f6bea62fb6365fde01baf68faa12318677ee7969243646525ee3fbc8cb81ec4b"

  livecheck do
    url "http://www.swftools.org/download.html"
    regex(/href=.*?swftools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  conflicts_with "swftools", because: "Homebrew version (missing features)"
  conflicts_with "swftools-stable", because: "Stable version"
  conflicts_with "swftools-head", because: "HEAD version"

  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "fontconfig"

  def install
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos1>=0)", "if(pos1>=(char *)0)"
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos2>=0)", "if(pos2>=(char *)0)"
    inreplace "lib/jpeg.c", "#define HAVE_BOOLEAN", "#define TRUE (1==1)\n#define FALSE (!TRUE)\n#define HAVE_BOOLEAN"
    inreplace "lib/as3/registry.h" do |s|
      s.gsub! /^classinfo_t voidclass;/, "// classinfo_t voidclass;"
    end
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(sname))", "int giferr; if ((gft = DGifOpenFileName(sname, &giferr))"
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(s))", "int giferr; if ((gft = DGifOpenFileName(s, &giferr))"
    inreplace "src/gif2swf.c", "DGifCloseFile(gft);", "int giferr2; DGifCloseFile(gft, &giferr2);"
    inreplace "src/gif2swf.c", "#define MAX_INPUT_FILES", "void PrintGifError(void) { int ret; fprintf(stderr, \"GIF-LIB: %s\\n\", GifErrorString(ret)); }\n#define MAX_INPUT_FILES"
    inreplace "configure", "/usr/include/fontconfig", "#{Formula['fontconfig'].opt_include}/fontconfig"
    system "./configure", "--prefix=#{prefix}"
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
