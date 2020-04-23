{ pkgs ? import ./nix { } }:
with pkgs;
let
  linters = [ shellcheck languagetool vim-vint nodePackages.write-good hlint ];
  # formatters = [ shfmt nixfmt python37Packages.black haskellPackages.brittany ];
  formatters = [ shfmt nixfmt python37Packages.black ];
  bins = [
    perl
    yarn
    universal-ctags
    tmux
    bat
    exa
    clojure-lsp
    (import sources.ghcide-nix { }).ghcide-ghc883
  ];

  nvim = (neovim-unwrapped.overrideAttrs (o: {
    version = "master";
    src = sources.neovim;
    buildInputs = o.buildInputs ++ [ utf8proc ];
  }));
  nvimWrapper = callPackage
    (sources.nixpkgs + "/pkgs/applications/editors/neovim/wrapper.nix") {
      nodejs = nodejs_latest;
    };
  myNvim = nvimWrapper nvim {
    vimAlias = true;
    viAlias = true;
    withNodeJs = true;
  };

  binPath = lib.makeBinPath (linters ++ formatters ++ bins);

in stdenv.mkDerivation {
  name = "nvim";
  buildInputs = [ makeWrapper ];
  buildCommand = ''
    makeWrapper "${myNvim}/bin/nvim" "$out/bin/nvim" --suffix PATH : ${binPath}
    ln -sfn "$out/bin/nvim" "$out/bin/vim"
    ln -sfn "$out/bin/nvim" "$out/bin/vi"
  '';
  preferLocalBuild = true;
}
