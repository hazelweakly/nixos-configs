{
  system = "x86_64-linux";
  modules = [
    ({ lib, config, ... }: {
      networking.hostName = "Hazels-P16";
      # environment.etc.hostname = lib.mkIf (config.networking.hostName != "") {
      #   text = lib.mkDefault (config.networking.hostName + "\n");
      # };
    })
    # ({ pkgs, lib, userProfile, systemProfile, ... }: {
    #   imports = lib.optionals systemProfile.isWork [ ../modules/work.nix ];
    #   home-manager.users.${userProfile.name} = { lib, ... }: {
    #     home.username = userProfile.name;
    #     home.homeDirectory = lib.mkForce userProfile.home;
    #     imports = lib.optionals systemProfile.isWork [ ../home/work.nix ];
    #   };
    # })
    # ({ pkgs, lib, userProfile, ... }: {
    #   users.users.${userProfile.name} = {
    #     home = userProfile.home;
    #     shell = pkgs.zsh;
    #   };
    #   nix.settings.trusted-users = [ userProfile.name ];
    #   home-manager.users = {
    #     root = import ../home/users/root.nix;
    #     ${userProfile.name} = import ../home/users/hazelweakly.nix;
    #   };
    # })
    ({
      imports = [ ./hardware-configuration.nix ./configuration.nix ../modules/encryption.nix ];
    })
  ];
}
