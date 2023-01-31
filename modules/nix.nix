{ pkgs, lib, inputs, self, ... }:
with builtins;
{
  # services.nix-daemon.enable = true; # darwin only
  # system.stateVersion = 4; # darwin only
  nix.package = pkgs.nixUnstable;
  nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.settings.keep-outputs = true;
  nix.settings.keep-derivations = true;
  nix.settings.auto-optimise-store = true;

  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (self.lib.inputsWithPkgs inputs);
  nix.registry = mapAttrs (_: v: { flake = v; }) (self.lib.inputsWithOutputs inputs);
  environment.etc = lib.mapAttrs' (n: v: self.lib.nameValuePair "nix/inputs/${n}" { source = v.outPath; }) inputs;
}
