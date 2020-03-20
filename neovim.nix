{ pkgs ? import ./nix { } }:
with pkgs;
let
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
    extraPython3Packages = (p: with p; [ black ]);
  };
in symlinkJoin {
  name = "nvim";
  paths = [ myNvim perl nixfmt yarn universal-ctags tmux shfmt bat ];
}
