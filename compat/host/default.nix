let
  flake = import ../flake-compat.nix;
  hostname = with builtins; head (split "\n" (readFile /etc/hostname));
  system = builtins.currentSystem;
  cfg =
    if system == "x86_64-darwin" then flake.darwinConfigurations
    else if system == "x86_64-linux" then flake.nixosConfigurations else { };
in
cfg.${hostname}
