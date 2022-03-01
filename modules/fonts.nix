{ pkgs, ... }: {
  fonts.enableFontDir = true;
  fonts.fonts = [
    pkgs.open-sans
    pkgs.victor-mono
    pkgs.luxi
    (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
  ];
}
