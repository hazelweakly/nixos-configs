{ self, inputs, hostConfig, ... }: builtins.attrValues (self.lib.rake ./.) ++ [
  ../cachix.nix
  inputs.home-manager.darwinModules.home-manager
  {
    security.pam.sudoTouchIdAuth.enable = true;

    programs.zsh.enable = true;
    programs.zsh.promptInit = "";
    programs.zsh.enableCompletion = false;
    programs.zsh.enableBashCompletion = false;
  }
  {
    networking.hostName = hostConfig.hostName;
    environment.etc.hostname.text = ''
      ${hostConfig.hostName}
    '';
  }
]
