final: prev: rec {
  neovim-nightly = final.inputs.neovim-flake.packages.${prev.system}.neovim;
  mkalias = final.inputs.mkalias.packages.${prev.system}.mkalias;
}
