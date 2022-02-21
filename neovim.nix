{ pkgs, ... }:
with pkgs;
let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: pkgs.lib.optionals (isBroken p) [ p ]);
  luaWith = neovim-unwrapped.lua.withPackages (p: [ lua-nuspell p.luarocks ]);
  dicts = [ hunspellDicts.en_US hunspellDicts.en_US-large ];
  path = lib.makeBinPath (builtins.sort (a: b: a.name < b.name) (nonBrokenPkgs [
    actionlint
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
    (python3.withPackages (p: [ p.black p.pynvim p.isort ]))
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

  # Load the direnv environment of root before starting. This basically
  # unloads the current direnv environment, which lets us change $PATH using
  # makeWrapper. If we don't do this, the direnv vim plugin will errnously
  # unload our injected $PATH once we leave the starting directory.
  # We use bash here because the wrapperArgs runs inside bash, regardless of
  # the shell the system uses
  preRun = ''
    pushd /
    eval "$(direnv export bash)"
    popd
  '';

  stuff = rec {
    neovimConfig' = (neovimUtils.makeNeovimConfig {
      withNodeJs = true;
      extraPython3Packages = p: [ p.black p.isort ];
      extraLuaPackages = p: [ lua-nuspell p.luarocks ];
      wrapRc = false;
      vimAlias = true;
      viAlias = true;
    });
    neovimConfig = neovimConfig' // {
      manifestRc = null;
      # This is fragile. For your sanity, create the string _here_ so that
      # nothing gets wrapped again by wrapNeovimUnstable
      wrapperArgs =
        (lib.escapeShellArgs (lib.take 2 neovimConfig'.wrapperArgs))
          + " "
          + "--run '${preRun}' "
          + (lib.escapeShellArgs (lib.sublist 2 2 neovimConfig'.wrapperArgs))
          + " "
          + (lib.concatStringsSep " " [
          "--suffix"
          "PATH"
          ":"
          path
          "--suffix"
          "DICPATH"
          ":"
          (lib.makeSearchPath "share/hunspell" dicts)
        ])
          + " "
          # forgive me, for I have sinned
          # however I am weary and this shit took an entire day to debug
          # remove the hideous hacks when this is merged into unstable
          # https://github.com/NixOS/nixpkgs/pull/159394
          + (lib.replaceStrings [ "--prefix" "';'" ] [ "--set" "" ] (lib.escapeShellArgs (lib.drop 4 neovimConfig'.wrapperArgs)));
    };
  };
  nv = wrapNeovimUnstable neovim-unwrapped stuff.neovimConfig;
in
# gonna keep this nonsense for now cause it makes it easier to debug things
(nv // {
  passthru = (nv.passthru or { }) // {
    inherit (stuff) neovimConfig neovimConfig';
  };
})
