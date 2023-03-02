{ pkgs, ... }: {
  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";
}
