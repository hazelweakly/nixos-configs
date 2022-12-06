{
  nix = {
    settings.substituters = [
      "https://devenv.cachix.org"
    ];
    settings.trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
}
