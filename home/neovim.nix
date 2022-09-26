{ pkgs, ... }:

let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: pkgs.lib.optionals (isBroken p) [ p ]);
  path = builtins.sort (a: b: a.name < b.name) (with pkgs; nonBrokenPkgs [
    actionlint
    bat
    binutils
    blackd-client
    buildifier
    cmake
    direnv
    exa
    gcc
    git
    go
    haskellPackages.cabal-fmt
    haskellPackages.hadolint
    jq
    languagetool
    libcxx
    ltex-ls
    myNodePackages
    nodejs
    neovim-remote
    nixpkgs-fmt
    perl
    prettierme
    rnix-lsp
    shellcheck
    shellharden
    shfmt
    stylua
    taplo-lsp
    terraform
    tmux
    tree-sitter
    universal-ctags
    watchman
    yarn
    zig
    zk
  ]);

  myNeovim = pkgs.wrapNeovimUnstable
    (pkgs.neovim-unwrapped.overrideAttrs
      (o: {
        buildInputs = (o.buildInputs or [ ]) ++ [ pkgs.stdenv.cc.cc.lib ];
      }))
    ((pkgs.neovimUtils.makeNeovimConfig {
      extraLuaPackages = p: [ p.luarocks ];
      withNodeJs = true;
      vimAlias = true;
      viAlias = true;
      wrapRc = false;
    }) // {
      wrapperArgs = [ "--prefix" "PATH" ":" "${pkgs.lib.makeBinPath path}" ];
    });
in
{
  home.packages = [ myNeovim ];
}
