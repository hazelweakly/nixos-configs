{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    programs.zsh.enable = true;
    programs.zsh.promptInit = "";
    programs.zsh.enableCompletion = false;
    programs.zsh.enableBashCompletion = false;
    environment.shells = [ pkgs.zsh ];
  }
  (lib.optionalAttrs systemProfile.isLinux {
    users.defaultUserShell = pkgs.zsh;
  })
]
