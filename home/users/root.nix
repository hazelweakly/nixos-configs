{ pkgs, ... }: {
  home.homeDirectory = pkgs.lib.mkForce "/var/root";
  home.stateVersion = "22.11";
  xdg.enable = true;
  programs.zsh.enable = true;
}
