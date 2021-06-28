channels: final: prev: rec {
  __dontExport = true;

  neovim-nightly = final.inputs.neovim-flake.packages.${prev.system}.neovim.overrideAttrs (o: {
    buildInputs = prev.neovim-unwrapped.buildInputs ++ [ tree-sitter ];
  });
  rnix-lsp = prev.callPackage ../rnix-lsp.nix { };
  tree-sitter = prev.tree-sitter.overrideAttrs (o: rec {
    # can't update cargoSha256 directly
    cargoDeps = o.cargoDeps.overrideAttrs (_: {
      outputHash = "sha256-iPEOIsdAdK+lWIcxHeljpaaiDvlayXazonj2RRqYe3I=";
      inherit src;
    });
    version = "0.20";
    src = final.inputs.tree-sitter;
  });
}
