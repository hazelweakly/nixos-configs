{ pkgs ? import ./nix { } }:
with pkgs;
let
  linters = [ shellcheck languagetool vim-vint nodePackages.write-good hlint ];
  formatters = [ shfmt nixfmt python37Packages.black haskellPackages.brittany ];
  nvim = (neovim-unwrapped.overrideAttrs (o: {
    version = "master";
    src = sources.neovim;
    buildInputs = o.buildInputs ++ [ utf8proc ];
  }));
  nvimWrapper = callPackage
    "${sources.nixpkgs}/pkgs/applications/editors/neovim/wrapper.nix" {
      nodejs = nodejs_latest;
    };
  myNvim = nvimWrapper nvim {
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
  };
in symlinkJoin {
  name = "nvim";
  paths = [ myNvim perl yarn universal-ctags tmux bat clojure-lsp ] ++ linters
    ++ formatters;
}
