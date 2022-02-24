{ pkgs, lib, inputs, self, ... }:
let l = import ../lib.nix; in
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
  '';

  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (l.inputsWithPkgs inputs);
  nix.registry = mapAttrs (_: v: { flake = v; }) (l.inputsWithOutputs inputs);
  environment.etc = lib.mapAttrs' (n: v: l.nameValuePair "nix/inputs/${n}" { source = v.outPath; }) inputs;
}
