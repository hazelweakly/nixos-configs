{ pkgs, ... }: {
  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.variables.SHELL = "/run/current-system/sw/bin/zsh";
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";
}
