{ pkgs, config, inputs, ... }: {
  imports = [
    ./modules/alias-pkgs.nix
    ./modules/defaults.nix
    ./modules/environment.nix
    ./modules/fonts.nix
    ./modules/homebrew.nix
    ./modules/launchd.nix
    ./modules/nix.nix
    ./modules/packages.nix
  ];

  networking.hostName = "Hazels-MacBook-Pro";
  security.pam.sudoTouchIdAuth.enable = true;

  programs.zsh.enable = true;
  programs.zsh.promptInit = "";
  programs.zsh.enableCompletion = false;
  programs.zsh.enableBashCompletion = false;
}
