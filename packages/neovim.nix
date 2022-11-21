{ lib
, bat
, cargo
, direnv
, exa
, git
, jq
, gopls
, nil
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
, vimPlugins
}:

let
  isBroken = pkg: (builtins.tryEval (builtins.deepSeq pkg.outPath pkg)).success;
  nonBrokenPkgs = builtins.concatMap (p: lib.optionals (isBroken p) [ p ]);
  path = builtins.sort (a: b: a.name < b.name) (nonBrokenPkgs [
    bat
    direnv
    exa
    git
    jq
    nil
    nixpkgs-fmt
    nodejs
    neovim-remote
    terraform
    tree-sitter
    watchman
    yarn
  ]);

  args.wrapperArgs = config.wrapperArgs ++ [ "--prefix" "PATH" ":" "${lib.makeBinPath path}" ];
  dotfiles = ../dots/nvim;

  config = neovimUtils.makeNeovimConfig {
    extraLuaPackages = p: [ p.luarocks ];
    withNodeJs = true;
    withRuby = false;
    vimAlias = true;
    viAlias = true;
    wrapRc = false;
    plugins = [{
      plugin = vimPlugins.nvim-treesitter.withAllGrammars;
      optional = false;
    }];
  };

  myNeovim = wrapNeovimUnstable
    (neovim-unwrapped.overrideAttrs
      (o: { buildInputs = (o.buildInputs or [ ]) ++ [ stdenv.cc.cc.lib ]; }))
    (config // args);
in

myNeovim // {
  passthru = (myNeovim.passthru or { }) // {
    inherit args; inherit (myNeovim) override; inherit dotfiles;
  };
}
