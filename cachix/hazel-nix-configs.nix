{
  nix = {
    settings.substituters = [
      "https://hazel-nix-configs.cachix.org"
    ];
    settings.trusted-public-keys = [
      "hazel-nix-configs.cachix.org-1:eEwA4AP2bcPFmJqIjjl+PYlw/7ABhpq0EtHmmm8k+ic="
    ];
  };
}
