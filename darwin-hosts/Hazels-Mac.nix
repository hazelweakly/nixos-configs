{
  system = "aarch64-darwin";
  modules = [{ networking.hostName = "Hazels-Mac"; }];
  specialArgs = {
    userProfile = rec {
      name = "hazel";
      home = "/Users/${name}";
      flakeDir = home + "/src/personal/nixos-configs";
    };
    systemProfile = rec {
      isWork = true;
      isLinux = false;
      isDarwin = !isLinux;
    };
  };
}
