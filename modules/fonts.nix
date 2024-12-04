{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    fonts.packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-extra
      pkgs.zilla-slab
      pkgs.open-sans
      pkgs.victor-mono
      pkgs.nerd-fonts.victor-mono
    ];
  }
  (lib.optionalAttrs systemProfile.isLinux {
    fonts.fontconfig.defaultFonts = {
      monospace = [ "VictorMono Nerd Font" ];
      sansSerif = [ "Open Sans" ];
      serif = [ "Noto Serif" ];
    };

    console.font = "latarcyrheb-sun32";
    console.keyMap = "us";
  })
]
