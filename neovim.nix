{ pkgs ? import ./nix { } }:
with pkgs;
let
  path = lib.makeBinPath (builtins.sort (a: b: a.name < b.name)
    ([ shellcheck languagetool vim-vint haskellPackages.hadolint ] ++ [
      python-language-server
      clojure-lsp
      universal-ctags
      neuron
      dhall-lsp-server
    ] ++ [ perl binutils libcxx gcc ]
      ++ [ yarn bat exa direnv git jq tmux watchman neovim-remote ]
      ++ [ buildifier shfmt nixfmt ]
      ++ [ python3Packages.black haskellPackages.cabal-fmt ]));
  v = neovim-unwrapped.overrideAttrs (o: {
    src = sources.neovim;
    buildInputs = o.buildInputs ++ [ pkgs.tree-sitter ];
  });
  c = (neovimUtils.override { nodejs = nodejs_latest; }).makeNeovimConfig {
    withNodeJs = true;
    extraPython3Packages = p: [ p.black ];
  };
  nvim = (wrapNeovimUnstable.override { nodejs = nodejs_latest; }) v (c // {
    wrapperArgs =
      lib.escapeShellArgs (c.wrapperArgs ++ [ "--suffix" "PATH" ":" path ]);
    vimAlias = true;
    viAlias = true;
  });
in nvim
