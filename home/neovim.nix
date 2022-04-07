{ config, pkgs, ... }:

with pkgs;
let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: pkgs.lib.optionals (isBroken p) [ p ]);
  luaWith = neovim-unwrapped.lua.withPackages (p: [ lua-nuspell p.luarocks ]);
  dicts = [ hunspellDicts.en_US hunspellDicts.en_US-large ];
  path = builtins.sort (a: b: a.name < b.name) (nonBrokenPkgs [
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
    isortd
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

  extraLuaPackages = p: [ p.luarocks lua-nuspell ];
  nv_lua = pkgs.neovim-unwrapped.lua;
  luaPackages = extraLuaPackages nv_lua.pkgs;
  extraMakeWrapperLuaCArgs = ''--set LUA_CPATH '${lib.concatMapStringsSep ";" nv_lua.pkgs.getLuaCPath luaPackages}' '';
  extraMakeWrapperLuaArgs = ''--set LUA_PATH '${lib.concatMapStringsSep ";" nv_lua.pkgs.getLuaPath luaPackages}' '';

  # Load the direnv environment of root before starting. This basically
  # unloads the current direnv environment, which lets us change $PATH using
  # makeWrapper. If we don't do this, the direnv vim plugin will errnously
  # unload our injected $PATH once we leave the starting directory.
  # We use bash here because the wrapperArgs runs inside bash, regardless of
  # the shell the system uses
  preRun = ''
    {
      pushd /
      eval "$(direnv export bash)"
      popd
    } >/dev/null
  '';

in
{
  imports = [ ./neovim-module.nix ];

  programs.myneovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withRuby = true;
    withPython3 = true;
    inherit extraLuaPackages;
    extraPackages = path;
    manifestRc = false;
    preWrapperArgs = [
      "--run"
      "'${preRun}'"
    ];
    postWrapperArgs = [
      "--suffix"
      "DICPATH"
      ":"
      (lib.makeSearchPath "share/hunspell" dicts)
      extraMakeWrapperLuaArgs
      extraMakeWrapperLuaCArgs
    ];
  };
}
