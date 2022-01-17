{ pkgs, ... }:
with pkgs;
let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: pkgs.lib.optionals (isBroken p) [ p ]);
  luaWith = luajit_2_1.withPackages (p: [ lua-nuspell p.luarocks ]);
  dicts = [ hunspellDicts.en_US hunspellDicts.en_US-large ];
  path = lib.makeBinPath (builtins.sort (a: b: a.name < b.name) (nonBrokenPkgs [
    bat
    binutils
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
    luaWith
    myNodePackages
    neovim-remote
    # nodePackages.prettier
    (nuspellWithDicts dicts)
    nixpkgs-fmt
    perl
    (python3.withPackages (p: [ p.black p.pynvim ]))
    rnix-lsp
    shellcheck
    shellharden
    stylua
    taplo-lsp
    terraform
    tmux
    tree-sitter
    universal-ctags
    watchman
    yarn
    zk
  ]));
  c = (neovimUtils.override { nodejs = nodejs_latest; }).makeNeovimConfig {
    withNodeJs = true;
    extraPython3Packages = p: [ p.black p.pynvim ];
    extraLuaPackages = p: [ lua-nuspell p.luarocks ];
  };
in
(wrapNeovimUnstable.override { nodejs = nodejs_latest; }) neovim-nightly (c
  // {
  wrapperArgs = lib.escapeShellArgs (c.wrapperArgs ++ [
    "--suffix"
    "PATH"
    ":"
    path
    "--suffix"
    "DICPATH"
    ":"
    (lib.makeSearchPath "share/hunspell" dicts)
  ]);
  vimAlias = true;
  viAlias = true;
  wrapRc = false;
})
