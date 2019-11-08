{ pkgs, lib, ... }:

{
  home.packages = lib.mkForce [];
  fonts.fontconfig.enable = true;

  programs.zsh = {
    enable = true;
  };

  # programs.firefox = {
  #   enable = false;
  # };

  programs.home-manager = {
    enable = true;
    path = "..";
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
  };
}
