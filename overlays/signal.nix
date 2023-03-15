final: prev: {
  # https://github.com/NixOS/nixpkgs/pull/220427
  signal-desktop-beta = prev.signal-desktop-beta.overrideAttrs (o: {
    version = "6.10.0-beta.1";
    hash = "sha256-A8jpYDWiCCBadRDzmNVxzucKPomgXlqdyeGiYp+1Byo=";
  });
}
