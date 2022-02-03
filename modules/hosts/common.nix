{ self, inputs, ... }: [
  ../../cachix.nix
  ../alias-pkgs.nix
  ../defaults.nix
  ../environment.nix
  ../fonts.nix
  ../home-manager.nix
  ../homebrew.nix
  ../launchd.nix
  ../nix.nix
  ../packages.nix
  ../pam.nix
  ../work.nix
  inputs.home-manager.darwinModules.home-manager
  {
    # needed for <darwin> so that darwin-option works correctly
    nix.nixPath = [ "darwin=/etc/nix/inputs/nix-darwin" ];
    environment.darwinConfig = "/etc/nix/inputs/self/compat/config.nix";
    security.pam.sudoTouchIdAuth.enable = true;

    programs.zsh.enable = true;
    programs.zsh.promptInit = "";
    programs.zsh.enableCompletion = false;
    programs.zsh.enableBashCompletion = false;
  }
]
