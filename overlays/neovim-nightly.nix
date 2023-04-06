final: prev: rec {
  neovim-unwrapped = neovim-nightly.override { tree-sitter = final.tree-sitter; }; # Needed so that neovim-remote picks up the right neovim
  neovim-nightly = final.inputs.neovim-flake.packages.${prev.system}.neovim;
  neovim-remote = prev.neovim-remote.overridePythonAttrs (o: { doCheck = false; });
}
