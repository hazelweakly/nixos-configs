{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    home.stateVersion = "22.11";
    xdg.enable = true;
    programs.zsh.enable = true;
  }
  (lib.optionals systemProfile.isDarwin {
    home.homeDirectory = pkgs.lib.mkForce "/var/root";
  })
]
