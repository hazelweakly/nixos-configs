final: prev: rec {
  neovim-unwrapped = neovim-nightly; # Needed so that neovim-remote picks up the right neovim
  neovim-nightly =
    final.inputs.neovim-nightly-overlay.packages.${prev.system}.neovim;
}
