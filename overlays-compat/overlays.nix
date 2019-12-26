# https://nixos.wiki/wiki/Overlays
self: super:
with super.lib;
let
  eval = import <nixpkgs/nixos/lib/eval-config.nix>;
  paths =
    (eval { modules = [ (import <nixos-config>) ]; }).config.nixpkgs.overlays;
in foldl' (flip extends) (_: super) paths self
