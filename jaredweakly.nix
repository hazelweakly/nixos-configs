{ config, ... }: {
  networking.hostName = "hazelweakly";
  age.sshKeyPaths =
    [ "${config.users.users.hazel.home}/.ssh/id_ed25519" ]
    ++ map (e: e.path) config.services.openssh.hostKeys;
}
