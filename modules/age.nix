{ config, pkgs, lib, inputs, self, ... }: {
  age.secrets =
    let
      secrets = builtins.removeAttrs (builtins.readDir ../secrets) [ "secrets.nix" ];
    in
    lib.mapAttrs' (k: v: { name = lib.removeSuffix ".age" k; value = { file = ../secrets/${k}; }; }) secrets;
  age.identityPaths =
    # lol i did this to myself
    lib.optionals pkgs.stdenv.isDarwin [ (config.users.users.hazelweakly.home + "/.ssh/id_ed25519") ]
    ++ lib.optionals pkgs.stdenv.isLinux [ (config.users.users.hazel.home + "/.ssh/id_ed25519") ]
  ;
}
