{ ... }: {
  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  homebrew.taps = [
    "homebrew/core"
    "homebrew/cask"
  ];
  homebrew.masApps = {
    Tailscale = 1475387142;
    # Xcode = # Pinned due to react native, do _not_ use mas.
  };
  homebrew.casks = [
    # "camo-studio" # need to install manually
    "docker"
    "mos"
    "obsidian"
    "openvpn-connect"
    "react-native-debugger"
    "rectangle"
  ];
}
