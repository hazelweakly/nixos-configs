{ pkgs, ... }: {
  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.open-sans
    pkgs.victor-mono
    (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
  ];
}
