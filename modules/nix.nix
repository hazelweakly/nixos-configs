{ pkgs, lib, inputs, self, ... }:
lib.mkMerge [
  {
    nix.package = pkgs.nixUnstable;
    nix.settings.experimental-features = [ "flakes" "nix-command" ];
    nix.settings.keep-outputs = true;
    nix.settings.keep-derivations = true;
    nix.settings.auto-optimise-store = true;

    nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (self.lib.inputsWithPkgs inputs);
    nix.registry = builtins.mapAttrs (_: v: { flake = v; }) (self.lib.inputsWithOutputs inputs);
    environment.etc = lib.mapAttrs' (n: v: self.lib.nameValuePair "nix/inputs/${n}" { source = v.outPath; }) inputs;
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    services.nix-daemon.enable = true;
    system.stateVersion = 4;
  })
]
