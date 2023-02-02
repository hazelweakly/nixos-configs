{ pkgs, lib, ... }: {
  fonts.fontconfig.defaultFonts = {
    monospace = [ "VictorMono Nerd Font" ];
    sansSerif = [ "Open Sans" ];
    serif = [ "Noto Serif" ];
  };
}
