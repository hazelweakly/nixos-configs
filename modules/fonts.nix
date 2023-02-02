{ pkgs, lib, ... }: {
  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.noto-fonts
    pkgs.noto-fonts-emoji
    pkgs.noto-fonts-extra
    pkgs.open-sans
    pkgs.victor-mono
    (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
  ];
}
