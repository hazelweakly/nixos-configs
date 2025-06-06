{ pkgs, lib, config, systemProfile, userProfile, ... }: lib.mkMerge [
  {
    environment.etc.hostname = lib.mkIf (config.networking.hostName != "") {
      text = lib.mkDefault (config.networking.hostName + "\n");
    };
  }
  (lib.optionalAttrs systemProfile.isDarwin {
    system.defaults.NSGlobalDomain = {
      "com.apple.mouse.tapBehavior" = 1;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.sound.beep.volume" = 0.0;
      "com.apple.trackpad.scaling" = 2.0;
      AppleFontSmoothing = 0;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticTextCompletionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
    };
    system.defaults.trackpad = {
      Clicking = true;
      Dragging = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
    system.defaults.finder = {
      FXEnableExtensionChangeWarning = false;
      _FXShowPosixPathInTitle = true;
      CreateDesktop = false;
      AppleShowAllExtensions = true;
    };

    system.defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;

    system.defaults.dock = {
      autohide = true;
      mru-spaces = true;
      tilesize = 32;
      show-recents = false;
      minimize-to-application = true;
      # hot corners
      wvous-br-corner = 1;
      wvous-br-modifier = 0;
      wvous-tl-corner = 2;
      wvous-tl-modifier = 0;
    };

    system.activationScripts.postActivation.text = ''
      sudo -u "${userProfile.name}" echo >&2 "setting up the dock icons"
      sudo -u "${userProfile.name}" defaults write com.apple.dock persistent-apps -array
      apps=(
          "/Applications/Firefox Developer Edition.app"
          "/Applications/Google Chrome.app"
          "${userProfile.home}/Applications/Nix/kitty.app"
          "/Applications/Slack.app"
          "/Applications/Signal.app"
          "/Applications/zoom.us.app"
          "/System/Applications/System Settings.app"
      )

      for dockItem in "''${apps[@]}" ; do
        sudo -u "${userProfile.name}" defaults write com.apple.dock persistent-apps -array-add '<dict><key>tile-data</key><dict><key>file-data</key><dict><key>_CFURLString</key><string>'"$dockItem"'</string><key>_CFURLStringType</key><integer>0</integer></dict></dict></dict>'
      done
      sudo -u "${userProfile.name}" killall Dock
    '';
  })
] // lib.optionalAttrs systemProfile.isDarwin {
  imports = [ ./defaults-options.nix ];
}
