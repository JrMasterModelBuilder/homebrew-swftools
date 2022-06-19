class SwftoolsStable < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "https://github.com/JrMasterModelBuilder/homebrew-swftools/releases/download/sources/swftools-0.9.2.tar.gz"
  version "0.9.2"
  sha256 "bf6891bfc6bf535a1a99a485478f7896ebacbe3bbf545ba551298080a26f01f1"

  livecheck do
    url "http://www.swftools.org/download.html"
    regex(/href=.*?swftools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  conflicts_with "swftools", because: "Homebrew version (missing features)"
  conflicts_with "swftools-dev", because: "Development snapshot"
  conflicts_with "swftools-head", because: "HEAD version"

  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"
  depends_on "fontconfig"

  def install
    inreplace "configure", "fftw_malloc", "fftwf_malloc"
    inreplace "swfs/Makefile.in", " -o -L $(pkgdatadir)/swfs/default_viewer.swf", ""
    inreplace "swfs/Makefile.in", " -o -L $(pkgdatadir)/swfs/default_loader.swf", ""
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos1>=0)", "if(pos1>=(char *)0)"
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos2>=0)", "if(pos2>=(char *)0)"
    inreplace "lib/jpeg.c", "#define HAVE_BOOLEAN", "#define TRUE (1==1)\n#define FALSE (!TRUE)\n#define HAVE_BOOLEAN"
    inreplace "lib/as3/registry.h" do |s|
      s.gsub! /^classinfo_t voidclass;/, "// classinfo_t voidclass;"
    end
    inreplace "lib/gfxpoly/poly.h", "type_t point_type;", "extern type_t point_type;"
    inreplace "src/swfc-feedback.h", "char* filename;", "extern char* filename;"
    inreplace "src/swfc-feedback.h", "int line;", "extern int line;"
    inreplace "src/swfc-feedback.h", "int column;", "extern int column;"
    inreplace "src/swfc-feedback.h", "void (*cleanUp)();", "extern void (*cleanUp)();"
    inreplace "src/swfc-feedback.c", "void syntaxerror", "char* filename = NULL;\nint line = 0;\nint column = 0;\nvoid (*cleanUp)() = NULL;\n\nvoid syntaxerror"
    inreplace "src/swfc-history.h", "FILTER* noFilters;", "extern FILTER* noFilters;"
    inreplace "src/swfc-history.h", "FILTER_BLUR* noBlur;", "extern FILTER_BLUR* noBlur;"
    inreplace "src/swfc-history.h", "FILTER_BEVEL* noBevel;", "extern FILTER_BEVEL* noBevel;"
    inreplace "src/swfc-history.h", "FILTER_DROPSHADOW* noDropshadow;", "extern FILTER_DROPSHADOW* noDropshadow;"
    inreplace "src/swfc-history.h", "FILTER_GRADIENTGLOW* noGradientGlow;", "extern FILTER_GRADIENTGLOW* noGradientGlow;"
    inreplace "src/swfc-history.c", "state_t* state_new", "FILTER* noFilters = NULL;\nFILTER_BLUR* noBlur = NULL;\nFILTER_BEVEL* noBevel = NULL;\nFILTER_DROPSHADOW* noDropshadow = NULL;\nFILTER_GRADIENTGLOW* noGradientGlow = NULL;\n\nstate_t* state_new"
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(sname))", "int giferr; if ((gft = DGifOpenFileName(sname, &giferr))"
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(s))", "int giferr; if ((gft = DGifOpenFileName(s, &giferr))"
    inreplace "src/gif2swf.c", "DGifCloseFile(gft);", "int giferr2; DGifCloseFile(gft, &giferr2);"
    inreplace "src/gif2swf.c", "#define MAX_INPUT_FILES", "void PrintGifError(void) { int ret; fprintf(stderr, \"GIF-LIB: %s\\n\", GifErrorString(ret)); }\n#define MAX_INPUT_FILES"
    inreplace "configure", "/usr/include/fontconfig", "#{Formula['fontconfig'].opt_include}/fontconfig"
    inreplace "configure", "/usr/include/lame", "#{Formula['lame'].opt_include}/lame"
    inreplace "configure", "/usr/local/include/lame", "#{Formula['lame'].opt_include}/lame"
    ENV["PYTHON_LIB"] = "/dev/null"
    ENV["PYTHON_INCLUDES"] = "/dev/null"
    ENV["RUBY"] = "/dev/null"
    system "./configure", "--prefix=#{prefix}"
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
