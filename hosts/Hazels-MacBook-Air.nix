{
  system = "aarch64-darwin";
  modules = [
    {
      networking.hostName = "Hazels-MacBook-Air";
      environment.etc.hostname.text = ''
        Hazels-MacBook-Air
      '';
    }
    {
      home-manager.users.hazel = { lib, ... }: {
        home.username = "hazel";
        home.homeDirectory = lib.mkForce "/Users/hazel";
        imports = [ ../home/work.nix ];
      };
    }
    ({ lib, ... }: {
      users.users.hazel.home = "/Users/hazel";
      home-manager.users = {
        root = import ../home/users/root.nix;
        hazel = import ../home/users/hazelweakly.nix;
      };
    })
  ];
}
