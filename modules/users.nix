{ pkgs, lib, systemProfile, userProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    home-manager.users = {
      root = import ../home/users/root.nix;
      ${userProfile.name} = import ../home/users/hazelweakly.nix;
    };

    users.users.${userProfile.name} = {
      home = userProfile.home;
      description = "Hazel Weakly";
      shell = pkgs.zsh;
    };
  }
  (lib.optionalAttrs systemProfile.isLinux {
    users.users.${userProfile.name} = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" ];
    };

    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  })
  (lib.optionalAttrs systemProfile.isDarwin { })
])
