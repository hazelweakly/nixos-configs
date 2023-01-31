{ pkgs, ... }: {
  environment.shells = with pkgs; [ bashInteractive zsh ];
  # environment.variables.SHELL = "/etc/profiles/per-user/hazel/bin/zsh";
  environment.variables.EDITOR = "nvim";
  environment.variables.VISUAL = "nvim";
}
