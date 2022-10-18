{ lib
, bat
, cargo
, direnv
, exa
, git
, jq
, nixpkgs-fmt
, nodejs
, neovim-remote
, terraform
, tree-sitter
, watchman
, yarn
, wrapNeovimUnstable
, neovim-unwrapped
, stdenv
, neovimUtils
}:

let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: lib.optionals (isBroken p) [ p ]);
  path = builtins.sort (a: b: a.name < b.name) (nonBrokenPkgs [
    bat
    cargo
    direnv
    exa
    git
    jq
    nixpkgs-fmt
    nodejs
    neovim-remote
    terraform
    tree-sitter
    watchman
    yarn
  ]);

  args.wrapperArgs = [ "--prefix" "PATH" ":" "${lib.makeBinPath path}" ];

  myNeovim = wrapNeovimUnstable
    (neovim-unwrapped.overrideAttrs
      (o: { buildInputs = (o.buildInputs or [ ]) ++ [ stdenv.cc.cc.lib ]; }))
    ((neovimUtils.makeNeovimConfig {
      extraLuaPackages = p: [ p.luarocks ];
      withNodeJs = true;
      withRuby = false;
      vimAlias = true;
      viAlias = true;
      wrapRc = false;
    }) // args);
in

myNeovim // {
  passthru = (myNeovim.passthru or { }) // { inherit args; inherit (myNeovim) override; };
}
