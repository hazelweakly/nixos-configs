final: prev: rec {
  # The override is so that neovim gets the right version of treesitter.
  # *That* is needed because I pin the "nixpkgs" from neovim to an old version
  # due to patch inconsistencies.
  #
  # NiX iS sUpErIoR (tm)
  neovim-unwrapped = neovim-nightly; # Needed so that neovim-remote picks up the right neovim
  neovim-nightly = (final.inputs.neovim-flake.packages.${prev.system}.neovim.override {
    tree-sitter = final.tree-sitter;
  });
  neovim-remote = prev.neovim-remote.overridePythonAttrs (o: { doCheck = false; });
}
