{
  system = "aarch64-darwin";
  modules = [{ networking.hostName = "Hazels-MacBook-Pro"; }];
  specialArgs = {
    userProfile = rec {
      name = "hazel";
      home = "/Users/${name}";
      flakeDir = home + "/src/personal/nixos-configs";
    };
    systemProfile = rec {
      isWork = false;
      isLinux = false;
      isDarwin = !isLinux;
    };
  };
}
