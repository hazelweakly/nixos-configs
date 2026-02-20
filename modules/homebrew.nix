{ lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.enable = true;
    homebrew.onActivation.autoUpdate = true;
    homebrew.onActivation.cleanup = "zap";
    homebrew.global.brewfile = true;
    homebrew.casks = [
      "claude"
      "deskpad"
      "displaylink"
      "drawio"
      "firefox@developer-edition"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "obs"
      "rectangle"
      "signal"
      "steam"
      "steermouse"
      "todoist"
      "visual-studio-code"
      "tor-browser"
    ];
  })

  (lib.optionalAttrs (systemProfile.isDarwin && !systemProfile.isWork) {
    homebrew.casks = [ "slack" "zoom" ];
  })
]
