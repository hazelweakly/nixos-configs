{ pkgs, lib, config, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    programs.ssh.startAgent = true;
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
      extraConfig = ''
        AcceptEnv COLORTERM LC_*
      '';
    };
  })
]
