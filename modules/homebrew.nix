{ lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.enable = true;
  })

  (lib.optionalAttrs (systemProfile.isDarwin && !systemProfile.isWork) {
    homebrew.onActivation.autoUpdate = true;
    homebrew.onActivation.cleanup = "zap";
    homebrew.global.brewfile = true;
    homebrew.casks = [
      "claude"
      "deskpad"
      "displaylink"
      "docker-desktop"
      "drawio"
      "firefox@developer-edition"
      "ghostty"
      "google-chrome"
      "karabiner-elements"
      "obs"
      "rectangle"
      "signal"
      "slack"
      "steam"
      "steermouse"
      "tailscale-app"
      "todoist-app"
      "tor-browser"
      "visual-studio-code"
      "vlc"
      "zoom"
    ];
  })
]
