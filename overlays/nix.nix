final: prev: {
  # remove when boost isn't an accidental runtime dependeny
  nix = prev.nix.overrideAttrs (o: {
    doCheck = false;
    doInstallCheck = false;
    strictDeps = false;
    disallowedReferences = [ ];
  });
}
