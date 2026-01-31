class SwftoolsDev < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "https://github.com/JrMasterModelBuilder/homebrew-swftools/releases/download/sources/swftools-2013-04-09-1007.tar.gz"
  version "2013-04-09-1007"
  sha256 "f6bea62fb6365fde01baf68faa12318677ee7969243646525ee3fbc8cb81ec4b"
  revision 1

  livecheck do
    url "http://www.swftools.org/download.html"
    regex(/href=.*?swftools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "lame"

  conflicts_with "swftools", because: "homebrew version (missing features)"
  conflicts_with "swftools-stable", because: "stable version"
  conflicts_with "swftools-head", because: "head version"

  def install
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos1>=0)", "if(pos1>=(char *)0)"
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos2>=0)", "if(pos2>=(char *)0)"
    inreplace "lib/jpeg.c", "#define HAVE_BOOLEAN", "#define TRUE (1==1)\n#define FALSE (!TRUE)\n#define HAVE_BOOLEAN"
    inreplace "lib/as3/registry.h" do |s|
      s.gsub!(/^classinfo_t voidclass;/, "// classinfo_t voidclass;")
    end
    inreplace "lib/as3/builtin.c", '{type: 8, &flash_utils_flash_proxy_constant_ns}', '{type: 8, ns: &flash_utils_flash_proxy_constant_ns}'
    inreplace "lib/as3/builtin.c", '{type: 8, &_AS3_constant_ns}', '{type: 8, ns: &_AS3_constant_ns}'
    inreplace "lib/gfxpoly/poly.h", "type_t point_type;", "extern type_t point_type;"
    inreplace "lib/devices/record.c", "#include \"record.h\"", "#include \"record.h\"\n#include \"dummy.h\""
    inreplace "src/swfc-feedback.h", "char* filename;", "extern char* filename;"
    inreplace "src/swfc-feedback.h", "int line;", "extern int line;"
    inreplace "src/swfc-feedback.h", "int column;", "extern int column;"
    inreplace "src/swfc-feedback.h", "void (*cleanUp)();", "extern void (*cleanUp)();"
    inreplace "src/swfc-feedback.c", "void syntaxerror", <<~'EOS'.strip
      char* filename = NULL;
      int line = 0;
      int column = 0;
      void (*cleanUp)() = NULL;
      void syntaxerror
    EOS
    inreplace "src/swfc-history.h", "FILTER* noFilters;", "extern FILTER* noFilters;"
    inreplace "src/swfc-history.h", "FILTER_BLUR* noBlur;", "extern FILTER_BLUR* noBlur;"
    inreplace "src/swfc-history.h", "FILTER_BEVEL* noBevel;", "extern FILTER_BEVEL* noBevel;"
    inreplace "src/swfc-history.h", "FILTER_DROPSHADOW* noDropshadow;", "extern FILTER_DROPSHADOW* noDropshadow;"
    inreplace "src/swfc-history.h", "FILTER_GRADIENTGLOW* noGradientGlow;", <<~'EOS'.strip
      extern FILTER_GRADIENTGLOW* noGradientGlow;
    EOS
    inreplace "src/swfc-history.c", "state_t* state_new", <<~'EOS'.strip
      FILTER* noFilters = NULL;
      FILTER_BLUR* noBlur = NULL;
      FILTER_BEVEL* noBevel = NULL;
      FILTER_DROPSHADOW* noDropshadow = NULL;
      FILTER_GRADIENTGLOW* noGradientGlow = NULL;
      state_t* state_new
    EOS
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(sname))", <<~'EOS'.strip
      int giferr; if ((gft = DGifOpenFileName(sname, &giferr))
    EOS
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(s))", <<~'EOS'.strip
      int giferr; if ((gft = DGifOpenFileName(s, &giferr))
    EOS
    inreplace "src/gif2swf.c", "DGifCloseFile(gft);", "int giferr2; DGifCloseFile(gft, &giferr2);"
    inreplace "src/gif2swf.c", "#define MAX_INPUT_FILES", <<~'EOS'.strip
      void PrintGifError(void) { int ret; fprintf(stderr, "GIF-LIB: %s\n", GifErrorString(ret)); }
      #define MAX_INPUT_FILES
    EOS
    inreplace "configure", "/usr/include/fontconfig", "#{Formula["fontconfig"].opt_include}/fontconfig"
    inreplace "configure", "/usr/include/lame", "#{Formula["lame"].opt_include}/lame"
    inreplace "configure", "/usr/local/include/lame", "#{Formula["lame"].opt_include}/lame"
    ENV["PYTHON_LIB"] = "/dev/null"
    ENV["PYTHON_INCLUDES"] = "/dev/null"
    ENV["RUBY"] = "/dev/null"
    args = []
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
    system "./configure", *args, *std_configure_args
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
