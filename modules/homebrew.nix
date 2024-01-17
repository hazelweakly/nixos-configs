{ lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.enable = true;
    homebrew.onActivation.autoUpdate = true;
    homebrew.onActivation.cleanup = "zap";
    homebrew.global.brewfile = true;
    homebrew.taps = [
      "homebrew/cask-drivers"
      "homebrew/cask-versions"
    ];
    homebrew.casks = [
      "firefox-developer-edition"
      "google-chrome"
      "karabiner-elements"
      "rectangle"
      "signal"
      "steam"
      "visual-studio-code"
    ];
  })

  (lib.optionalAttrs (systemProfile.isDarwin && !systemProfile.isWork) {
    homebrew.casks = [ "zoom" ];
  })
]
