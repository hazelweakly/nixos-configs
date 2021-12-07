{ pkgs, lib, inputs, self, ... }:
let l = import ../lib.nix; in
with builtins;
{
  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  system.stateVersion = 4;
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes
  '';

  nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (l.inputsWithPkgs inputs);
  nix.registry = mapAttrs (_: v: { flake = v; }) (l.inputsWithOutputs inputs);
  environment.etc = lib.mapAttrs' (n: v: l.nameValuePair "nix/inputs/${n}" { source = v.outPath; }) inputs;

  nixpkgs.overlays = [ inputs.rust-overlay.overlay (_:_: { inherit inputs; }) ] ++ (attrValues (self.overlays));
}
