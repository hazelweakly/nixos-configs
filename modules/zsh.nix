{ pkgs, ... }: {
  programs.zsh.enable = true;
  programs.zsh.promptInit = "";
  programs.zsh.enableCompletion = false;
  programs.zsh.enableBashCompletion = false;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = [ pkgs.zsh ];
}
