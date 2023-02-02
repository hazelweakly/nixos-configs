{ pkgs, ... }: {
  programs.zsh.enable = true;
  programs.zsh.promptInit = "";
  programs.zsh.enableCompletion = false;
  programs.zsh.enableBashCompletion = false;
  environment.shells = [ pkgs.zsh ];
}
