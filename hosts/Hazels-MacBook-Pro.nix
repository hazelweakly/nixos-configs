{
  system = "x86_64-darwin";
  modules = [
    {
      networking.hostName = "Hazels-MacBook-Pro";
      environment.etc.hostname.text = ''
        Hazels-MacBook-Pro
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
