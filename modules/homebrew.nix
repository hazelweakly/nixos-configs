{ lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.enable = true;
    homebrew.onActivation.autoUpdate = true;
    homebrew.onActivation.cleanup = "zap";
    homebrew.global.brewfile = true;
    homebrew.taps = [
      "homebrew/core"
      "homebrew/cask"
      "homebrew/cask-drivers"
    ];
    homebrew.casks = [
      "rectangle"
      "signal"
    ];
  })
]
