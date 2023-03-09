{ config, ... }: {
  nix.extraOptions = ''
    !include ${config.age.secrets.mercury.path}
  '';
}
