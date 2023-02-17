{ lib
, bat
, cargo
, direnv
, gnumake
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
, shellharden
, stylua
, lua-language-server
, watchman
, yarn
, wrapNeovimUnstable
, neovim-unwrapped
, stdenv
, neovimUtils
, vimUtils
, vimPlugins
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
    gnumake
    gopls
    jq
    neovim-remote
    nil
    nixpkgs-fmt
    nodejs
    shellharden
    stylua
    lua-language-server
    terraform
    tree-sitter
    watchman
    yarn
    stdenv.cc
  ]);

  # doing it the non obvious way like this automatically collects all the grammar dependencies for us.
  packDirArgs.myNeovimPackages = { start = [ (vimPlugins.nvim-treesitter.withPlugins (_: vimPlugins.nvim-treesitter.allGrammars)) ]; };
  treeSitterPlugin = vimUtils.packDir packDirArgs;

  args.wrapperArgs = config.wrapperArgs ++ [ "--prefix" "PATH" ":" "${lib.makeBinPath path}" ] ++ [ "--set" "TREESITTER_PLUGIN" treeSitterPlugin ];
  dotfiles = ../dots/nvim;

  config = neovimUtils.makeNeovimConfig {
    extraLuaPackages = p: [ p.luarocks ];
    withNodeJs = true;
    withRuby = false;
    vimAlias = true;
    viAlias = true;
    wrapRc = false;
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
