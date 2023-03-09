{ config, pkgs, lib, inputs, self, userProfile, ... }: {
  age.secrets =
    let
      secrets = builtins.removeAttrs (builtins.readDir ../secrets) [ "secrets.nix" ];
    in
    lib.mapAttrs' (k: v: { name = lib.removeSuffix ".age" k; value = { file = ../. + "/secrets/${k}"; }; }) secrets;

  age.identityPaths = [ (userProfile.home + "/.ssh/id_ed25519") ];
}
