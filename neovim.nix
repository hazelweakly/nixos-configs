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
  ]));
  c = (neovimUtils.override { nodejs = nodejs_latest; }).makeNeovimConfig {
    withNodeJs = true;
    extraPython3Packages = p: [ p.black p.pynvim ];
    extraLuaPackages = p: [ lua-nuspell p.luarocks ];
  };
  # Load the direnv environment of root before starting. This basically
  # unloads the current direnv environment, which lets us change $PATH using
  # makeWrapper. If we don't do this, the direnv vim plugin will errnously
  # unload our injected $PATH once we leave the starting directory.
  # We use bash here because the wrapperArgs runs inside bash, regardless of
  # the shell the system uses
  preRun = ''
    pushd / &>/dev/null
    eval "$(direnv export bash)"
    popd &>/dev/null
  '';
in
(wrapNeovimUnstable.override { nodejs = nodejs_latest; })
  neovim-nightly
  (c
    // {
    wrapperArgs = [ "--run" preRun ] ++ c.wrapperArgs ++ [
      "--suffix"
      "PATH"
      ":"
      path
      "--suffix"
      "DICPATH"
      ":"
      (lib.makeSearchPath "share/hunspell" dicts)
    ];
    vimAlias = true;
    viAlias = true;
    wrapRc = false;
  })
