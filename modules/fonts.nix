{ pkgs, ... }: {
  fonts.enableFontDir = true;
  fonts.fonts = [
    pkgs.opensans-ttf
    pkgs.victor-mono
    pkgs.luxi
    (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
  ];
}
