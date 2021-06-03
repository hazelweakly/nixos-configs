{ pkgs }:
with pkgs;
let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: pkgs.lib.optionals (isBroken p) [ p ]);
  path = lib.makeBinPath (builtins.sort (a: b: a.name < b.name) (nonBrokenPkgs [
    bat
    binutils
    buildifier
    clojure-lsp
    dhall-lsp-server
    direnv
    exa
    gcc
    git
    haskellPackages.cabal-fmt
    haskellPackages.hadolint
    jq
    languagetool
    libcxx
    neovim-remote
    neuron-notes
    nixpkgs-fmt
    rnix-lsp
    perl
    python3
    python3Packages.black
    python-language-server
    shellcheck
    shfmt
    sumneko-lua-language-server
    tmux
    tree-sitter
    universal-ctags
    vim-vint
    watchman
    yarn
  ]));
  c = (neovimUtils.override { nodejs = nodejs_latest; }).makeNeovimConfig {
    withNodeJs = true;
    extraPython3Packages = p: [ p.black ];
  };
in
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
  wrapRc = false;
})
