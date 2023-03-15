{ pkgs, lib, config, systemProfile, userProfile, modulesPath, ... }: lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [
      docker
      docker-compose
    ];
  }
  (lib.optionalAttrs systemProfile.isLinux {
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = false;
    virtualisation.docker.daemon.settings = {
      experimental = true;
      features.buildkit = true;
    };
    users.users.${userProfile.name}.extraGroups = [ "docker" ];
  })
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.casks = [
      "docker"
    ];
  })
]
