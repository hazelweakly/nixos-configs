{ pkgs, config, ... }: {
  imports = [ ./defaults-options.nix ];
  system.defaults.NSGlobalDomain = {
    "com.apple.mouse.tapBehavior" = 1;
    "com.apple.sound.beep.feedback" = 0;
    "com.apple.sound.beep.volume" = "0.0";
    "com.apple.trackpad.scaling" = "2.0";
    AppleFontSmoothing = 0;
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
  };
}
