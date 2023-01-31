{ pkgs, lib, inputs, self, ... }:
with builtins;
{
  # set nixpkgs.{config} options in flake.nix directly
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
  nix.package = pkgs.nix;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
    trusted-users = hazelweakly root
  '';

  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (self.lib.inputsWithPkgs inputs);
  nix.registry = mapAttrs (_: v: { flake = v; }) (self.lib.inputsWithOutputs inputs);
  environment.etc = lib.mapAttrs' (n: v: self.lib.nameValuePair "nix/inputs/${n}" { source = v.outPath; }) inputs;
}
