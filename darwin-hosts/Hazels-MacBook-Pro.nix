{
  system = "x86_64-darwin";
  modules = [
    ({ lib, config, ... }: {
      networking.hostName = "Hazels-MacBook-Pro";
      # environment.etc.hostname = lib.mkIf (config.networking.hostName != "") {
      #   text = lib.mkDefault (config.networking.hostName + "\n");
      # };
    })
    # {
    #   imports = [ ../modules/work.nix ];
    #   home-manager.users.hazelweakly = { lib, ... }: {
    #     home.username = "hazelweakly";
    #     home.homeDirectory = lib.mkForce "/Users/hazelweakly";
    #     imports = [ ../home/work.nix ];
    #   };
    # }
    # ({ lib, ... }: {
    #   users.users.hazelweakly.home = "/Users/hazelweakly";
    #   home-manager.users = {
    #     root = import ../home/users/root.nix;
    #     hazelweakly = import ../home/users/hazelweakly.nix;
    #   };
    # })
  ];
}
