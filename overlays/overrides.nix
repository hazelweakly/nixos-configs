channels: final: prev: {
  __dontExport = true;

  neovim-nightly = final.inputs.neovim-flake.packages.${prev.system}.neovim;
  rnix-lsp = prev.callPackage ../rnix-lsp.nix { };
}
