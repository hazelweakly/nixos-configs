{ hostname ? with builtins; head (split "\n" (readFile /etc/hostname)), ... }:
let flake = import ../flake-compat.nix;
in flake.defaultNix.nixosConfigurations.${hostname}
