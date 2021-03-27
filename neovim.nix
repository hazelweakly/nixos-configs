{ pkgs ? import ./nix { } }:
with pkgs;
let
  path = lib.makeBinPath (builtins.sort (a: b: a.name < b.name)
  # ([ shellcheck languagetool vim-vint haskellPackages.hadolint ] ++ [
    ([ shellcheck languagetool vim-vint ] ++ [
      python-language-server
      clojure-lsp
      universal-ctags
      neuron-notes
      # dhall-lsp-server
    ] ++ [ python3 perl binutils libcxx gcc tree-sitter ]
      ++ [ yarn bat exa direnv git jq tmux watchman neovim-remote ]
      ++ [ buildifier shfmt nixfmt ]
      ++ [ python3Packages.black haskellPackages.cabal-fmt ]));
  c = (neovimUtils.override { nodejs = nodejs_latest; }).makeNeovimConfig {
    withNodeJs = true;
    extraPython3Packages = p: [ p.black ];
  };
  nvim =
    (wrapNeovimUnstable.override { nodejs = nodejs_latest; }) neovim-nightly (c
      // {
        wrapperArgs = lib.escapeShellArgs (c.wrapperArgs ++ [
          "--suffix"
          "PATH"
          ":"
          path
          "--set"
          "EXPLAINSHELL_ENDPOINT"
          "http://localhost:5000"
        ]);
        vimAlias = true;
        viAlias = true;
      });
in nvim
