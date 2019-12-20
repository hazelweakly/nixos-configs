{ sources ? import ./sources.nix }:

let
  moz = import sources.nixpkgs-mozilla;
  rust = import "${sources.nixpkgs-mozilla}/rust-src-overlay.nix";

in import sources.nixpkgs {
  overlays = [ moz rust ];
  config = { allowUnfree = true; };
}
