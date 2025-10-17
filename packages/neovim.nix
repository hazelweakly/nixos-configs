{ lib
, pkgs
, neovimPackages ? with pkgs; [
    actionlint
    basedpyright
    bash-language-server
    bat
    black
    cargo
    direnv
    docker-compose-language-service
    dockerfile-language-server
    eza
    git
    gnumake
    gopls
    hadolint
    helm-ls
    isort
    jq
    lua-language-server
    neovim-remote
    neovim-unwrapped.lua
    nil
    nixpkgs-fmt
    nodePackages.prettier
    nodePackages.prettier_d_slim
    # nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodejs
    rust-analyzer
    shellcheck
    shellharden
    shfmt
    stylua
    taplo
    terraform
    terraform-ls
    tree-sitter
    # watchman
    yaml-language-server
    yarn
  ]
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
    stdenv.cc
  ] ++ neovimPackages);

  # This gives us a /parser directory with all the treesitter parsers in it, so that when it's added to the RTP, neovim gets all the parsers.
  # See nvim/lua/plugins/nvim-treesitter.lua for how this (and the TREESITTER_PLUGIN variable) gets used.
  aggregatedParsers = pkgs.symlinkJoin { name = "parsers"; paths = builtins.map neovimUtils.grammarToPlugin vimPlugins.nvim-treesitter.allGrammars; };

  # doing it the non obvious way like this automatically collects all the grammar dependencies for us.
  packDirArgs.myNeovimPackages = { start = [ vimPlugins.nvim-treesitter.withAllGrammars ]; };
  treeSitterPlugin = neovimUtils.packDir packDirArgs;

  args.wrapperArgs = config.wrapperArgs ++ [ "--prefix" "PATH" ":" "${lib.makeBinPath path}" ] ++ [ "--set" "TREESITTER_PLUGIN" treeSitterPlugin ] ++ [ "--set" "TREESITTER_PARSERS" aggregatedParsers ];
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
