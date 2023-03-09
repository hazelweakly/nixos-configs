{
  nix = {
    settings.substituters = [
      "https://pre-commit-hooks.cachix.org"
    ];
    settings.trusted-public-keys = [
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };
}

