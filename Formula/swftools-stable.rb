class SwftoolsStable < Formula
  desc "SWF manipulation and generation tools"
  homepage "http://www.swftools.org/"
  url "http://www.swftools.org/swftools-0.9.2.tar.gz"
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

  on_linux do
    depends_on "fontconfig"
  end

  def install
    inreplace "configure", "fftw_malloc", "fftwf_malloc"
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos1>=0)", "if(pos1>=(char *)0)"
    inreplace "lib/pdf/xpdf/GlobalParams.cc", "if(pos2>=0)", "if(pos2>=(char *)0)"
    inreplace "lib/jpeg.c", "#define HAVE_BOOLEAN", "#define TRUE (1==1)\n#define FALSE (!TRUE)\n#define HAVE_BOOLEAN"
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(sname))", "int giferr; if ((gft = DGifOpenFileName(sname, &giferr))"
    inreplace "src/gif2swf.c", "if ((gft = DGifOpenFileName(s))", "int giferr; if ((gft = DGifOpenFileName(s, &giferr))"
    inreplace "src/gif2swf.c", "DGifCloseFile(gft);", "int giferr2; DGifCloseFile(gft, &giferr2);"
    inreplace "src/gif2swf.c", "#define MAX_INPUT_FILES", "void PrintGifError(void) { printf(\"Unknown GIF error\\n\"); }\n#define MAX_INPUT_FILES"
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
