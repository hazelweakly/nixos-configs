{ sources ? import ./sources.nix, system ? builtins.currentSystem }:
let
  overlays = import ./overlays.nix { inherit sources; };
  config = import ./config.nix;
in import sources.nixpkgs { inherit config overlays system; }
