{
  system = "x86_64-linux";
  modules = [
    {
      networking.hostName = "Hazels-P16";
    }
    {
      home-manager.users.hazel = { lib, ... }: {
        home.username = "hazel";
        home.homeDirectory = lib.mkForce "/home/hazel";
      };
    }
    ({ pkgs, lib, ... }: {
      users.users.hazel.home = "/home/hazel";
      users.users.hazel.shell = pkgs.zsh;
      nix.settings.trusted-users = [ "hazel" ];
      home-manager.users = {
        root = import ../home/users/root.nix;
        hazel = import ../home/users/hazelweakly.nix;
      };
    })
    ({
      imports = [ ./hardware-configuration.nix ./configuration.nix ../modules/encryption.nix ];
    })
  ];
}
