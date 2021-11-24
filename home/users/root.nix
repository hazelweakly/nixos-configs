{ pkgs, ... }: {
  home.homeDirectory = pkgs.lib.mkForce "/var/root";
  xdg.enable = true;
  programs.zsh.enable = true;
}
