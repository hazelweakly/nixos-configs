{
  system = "x86_64-linux";
  modules = [
    {
      networking.hostName = "x86-64-linux";
    }
    {
      home-manager.users.hazelweakly = { lib, ... }: {
        home.username = "hazelweakly";
        home.homeDirectory = lib.mkForce "/Users/hazelweakly";
      };
    }
    ({ lib, ... }: {
      users.users.hazelweakly.home = "/Users/hazelweakly";
      home-manager.users = {
        root = import ../home/users/root.nix;
        hazelweakly = import ../home/users/hazelweakly.nix;
      };
    })
  ];
}
