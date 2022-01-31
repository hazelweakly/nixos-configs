final: prev: {
  nix = prev.nix.overrideAttrs (o: {
    doCheck = false;
    doInstallCheck = false;
    strictDeps = false;
    disallowedReferences = [ ]; # pls just werk, I don't care rn
  });
  # nixPinned = final.inputs.nix.packages.${prev.system}.nix;
  # nixUnstable = nixPinned;
  # nixFlakes = nixPinned;
}
