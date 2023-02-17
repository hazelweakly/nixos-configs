{
  imports = [
    ({ lib, config, ... }: {
      # networking.hostName = "Hazels-P16";
      environment.etc.hostname = lib.mkIf (config.networking.hostName != "") {
        text = lib.mkDefault (config.networking.hostName + "\n");
      };
    })
    ({ pkgs, lib, userProfile, ... }: {
      home-manager.users = {
        root = import ../home/users/root.nix;
        ${userProfile.name} = import ../home/users/hazelweakly.nix;
      };
    })
    ({ pkgs, lib, userProfile, ... }: {
      users.users.${userProfile.name} = {
        home = userProfile.home;
        shell = pkgs.zsh;
      };
      nix.settings.trusted-users = [ userProfile.name ];
    })
  ];
}
