final: prev: {
  neovim-nightly = final.inputs.neovim-flake.packages.${prev.system}.neovim;
}
