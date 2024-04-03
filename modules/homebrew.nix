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
      "caffeine"
      "deskpad"
      "drawio"
      "firefox-developer-edition"
      "google-chrome"
      "karabiner-elements"
      "rectangle"
      "signal"
      "steam"
      "steermouse"
      "todoist"
      "visual-studio-code"
    ];
  })

  (lib.optionalAttrs (systemProfile.isDarwin && !systemProfile.isWork) {
    homebrew.casks = [ "zoom" ];
  })
]
