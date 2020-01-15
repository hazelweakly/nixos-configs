{ lib, fetchzip }:

let pname = "Luxi-Mono";
in fetchzip rec {
  name = "${pname}-1.2.0";
  url = "https://www.fontsquirrel.com/fonts/download/${pname}";
  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*.ttf                           -d $out/share/fonts/truetype
    unzip -j $downloadedFile \*.txt                           -d "$out/share/doc/${name}"
  '';
  sha256 = "1g25v8h9lf75gd6c3bf43jmm4r76532j646fy4d6ysi9nmxrbrfl";

  meta = with lib; {
    homepage = "https://www.marksimonson.com/fonts/view/anonymous-pro";
    description = "TrueType font set intended for source code";
    longDescription = ''
      Luxi is a family of typefaces originally designed for the X Window System
      by Kris Holmes and Charles Bigelow from Bigelow & Holmes Inc. The Luxi
      typefaces are similar to Lucida – their previous font design.
    '';
    # maintainers = with maintainers; [ raskin rycee ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
