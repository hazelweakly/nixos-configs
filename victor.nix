{ lib, fetchurl, stdenv }:

let
  pname = "Victor-Mono";
  version = "1.2.0";
  name = "${pname}-${version}";
  regular = fetchurl {
    name = "${name}-Regular";
    url =
      "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/Regular/complete/Victor%20Mono%20Regular%20Nerd%20Font%20Complete.ttf";
    sha256 = "07ar0hqalbk8wllqz5v06njyjqqrfv0lsp392v8d3qp0z44gxybv";
  };
  bold = fetchurl {
    name = "${name}-Bold";
    url =
      "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/Bold/complete/Victor%20Mono%20Bold%20Nerd%20Font%20Complete.ttf";
    sha256 = "0an9xgr7ymsmk87rmqjv3cncm1h4hx10msiyvh5nk71465viabl3";
  };
  italic = fetchurl {
    name = "${name}-Italic";
    url =
      "https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/VictorMono/Italic/complete/Victor%20Mono%20Italic%20Nerd%20Font%20Complete.ttf";
    sha256 = "0ssnrbd6sarx2gllars20jjshcsq7p9vldxrm11f3v028xqpmjgk";
  };
in stdenv.mkDerivation {
  inherit name;
  # src = "${font}";
  baseInputs = [ regular bold italic ];
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    for i in $baseInputs; do
      install -m 644 $i $out/share/fonts/truetype/$(basename $i).ttf
    done
  '';
}
