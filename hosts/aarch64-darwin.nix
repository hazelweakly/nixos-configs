{
  system = "aarch64-darwin";
  modules = [
    {
      networking.hostName = "aarch64-darwin";
      environment.etc.hostname.text = ''
        aarch64-darwin
      '';
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
