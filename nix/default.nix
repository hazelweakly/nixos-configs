{ sources ? import ./sources.nix }:
let nixConfig = import ../nixpkgs.nix;
in import sources.nixpkgs { inherit (nixConfig.nixpkgs) overlays config; }
