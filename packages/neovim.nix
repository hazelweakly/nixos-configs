{ lib
, pkgs
, neovimPackages ? with pkgs; [
    actionlint
    bat
    black
    cargo
    # dhall-lsp-server
    direnv
    docker-ls
    exa
    git
    gnumake
    gopls
    # hadolint
    isort
    jq
    lua-language-server
    neovim-remote
    neovim-unwrapped.lua
    nil
    nixpkgs-fmt
    nodePackages.bash-language-server
    nodePackages.prettier
    nodePackages.prettier_d_slim
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodejs
    pyright
    rust-analyzer
    shellcheck
    shellharden
    shfmt
    stylua
    taplo
    terraform
    terraform-ls
    tree-sitter
    watchman
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
