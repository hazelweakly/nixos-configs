{ hostname ? with builtins; head (split "\n" (readFile /etc/hostname)), system ? builtins.currentSystem, ... }:
let
  flake = import ./flake-compat.nix;
  cfg =
    if system == "x86_64-darwin" then flake.defaultNix.darwinConfigurations
    else if system == "x86_64-linux" then flake.defaultNix.nixosConfigurations else { };
in
${cfg}.${hostname}.config
