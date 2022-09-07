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
  homebrew.casks = [
    "docker"
    "rectangle"
    "elgato-wave-link"
  ];
}
