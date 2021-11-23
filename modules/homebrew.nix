{ ... }: {
  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  homebrew.brews = [
    "cocoapods"
    "hopenpgp-tools"
    "hyperkit"
    "ios-deploy"
    "pinentry-mac"
    "ykman"
    "yubikey-personalization"
  ];
  homebrew.taps = [
    "borkdude/brew"
    "homebrew/cask"
    "homebrew/cask-drivers"
    "homebrew/cask-fonts"
    "homebrew/cask-versions"
    "homebrew/core"
    "homebrew/services"
  ];
  homebrew.masApps = {
    GarageBand = 682658836;
    Keynote = 409183694;
    Numbers = 409203825;
    Pages = 409201541;
    iMovie = 408981434;
    # Xcode = # Pinned due to react native, do _not_ use mas.
  };
  homebrew.casks = [
    "aptible"
    # "camo-studio" # need to install manually
    "docker"
    "gpg-suite"
    "hammerspoon"
    "hey"
    "mos"
    "obsidian"
    "openvpn-connect"
    "postico"
    "react-native-debugger"
    "rectangle"
    "visual-studio-code"
    "vlc"
    "yubico-authenticator"
    "yubico-yubikey-manager"
    "yubico-yubikey-personalization-gui"
  ];
}
