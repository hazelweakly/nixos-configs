{ ... }: {
  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  homebrew.taps = [
    "homebrew/core"
    "homebrew/cask"
    "homebrew/cask-drivers"
  ];
  # homebrew.masApps = {
  #   Tailscale = 1475387142;
  #   Zoom = 546505307;
  # };
  homebrew.casks = [
    "docker"
    "mos"
    "obsidian"
    # "openvpn-connect"
    # "react-native-debugger"
    "rectangle"
    "elgato-wave-link"
  ];
}
