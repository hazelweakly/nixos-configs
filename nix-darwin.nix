{ pkgs, config, inputs, ... }:
let switch-theme =
  pkgs.writeShellScriptBin "switch-theme" ''
    t="$1"
    shift
    if [ -z "$t" ]; then
      defaults read -g AppleInterfaceStyle >/dev/null 2>&1 && t=dark || t=light
    fi

    echo "$t" > $HOME/.local/share/theme
    case "$t" in
      dark) kitty_theme=${builtins.toString (./dots/kitty + "/tokyonight_night")} ;;
      light) kitty_theme=${builtins.toString (./dots/kitty + "/tokyonight_day")} ;;
    esac
    ln -sf $kitty_theme $HOME/.config/kitty_current_theme
    find /tmp/kitty* -maxdepth 1 -exec kitty @ --to=unix:{} set-colors -a -c $kitty_theme \;
    for v in $(nvr --serverlist); do nvr -s --remote-expr "SetTheme(\"$t\")" --servername $v --nostart >/dev/null & done
    wait
  '';
in
{
  environment.systemPackages = with pkgs; [
    # kitty
    terminal-notifier
    curl
    gitAndTools.gitFull
    git-lfs
    cachix
    file
    # timewarrior
    # taskwarrior
    # tasksh
    (callPackage ./neovim.nix { })
    neovim-remote
    ranger
    fup-repl
    # htop
    gcc
    openssh
    xhyve
    coreutils
    switch-theme
    _1password

    awscli2 # yey

    # Programs implicitly relied on in shell
    pistol
    exa
    gitAndTools.delta
    bat
    fd
    ripgrep
  ];
  environment.shells = with pkgs; [ bashInteractive zsh ];
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";
  environment.variables.EDITOR = "vim";
  environment.variables.TERMINFO_DIRS = "/Applications/kitty.app/Contents/Resources/kitty/terminfo";

  security.pam.sudoTouchIdAuth.enable = true;
  security.pam.u2fAuth.enable = true;
  security.pam.u2fAuth.options = [ "pinverification=0" ];

  fonts.enableFontDir = true;
  fonts.fonts = [ pkgs.opensans-ttf pkgs.victor-mono ];

  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  system.stateVersion = 4;
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes ca-references
  '';

  system.defaults.NSGlobalDomain = {
    "com.apple.mouse.tapBehavior" = 1;
    "com.apple.sound.beep.feedback" = 0;
    "com.apple.sound.beep.volume" = "0.0";
    "com.apple.trackpad.scaling" = "0.0";
    AppleFontSmoothing = 0;
    AppleShowScrollBars = "Automatic";
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSDocumentSaveNewDocumentsToCloud = false;
    _HIHideMenuBar = true;
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

  system.activationScripts.postActivation.text = builtins.concatStringsSep "\n" [
    config.system.activationScripts.pam.text # temp hack
  ];

  launchd.user.agents.dark-mode-notify = {
    path = [ switch-theme pkgs.neovim-remote config.environment.systemPath ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = "hazelweakly";
      GroupName = "staff";
      StandardOutPath = "/tmp/dark-mode-notify.stdout";
      StandardErrorPath = "/tmp/dark-mode-notify.stderr";
    };
    command = "${./dark-mode-notify.swift} ${switch-theme}/bin/switch-theme";
  };

  launchd.SoftResourceLimits.NumberOfFiles = 1048576;
  launchd.HardResourceLimits.NumberOfFiles = 1048576;

  programs.zsh.enable = true;
  programs.zsh.promptInit = "";
  programs.zsh.enableCompletion = false;
  programs.zsh.enableBashCompletion = false;

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  homebrew.brews = [
    "clj-kondo"
    "cocoapods"
    "hopenpgp-tools"
    "node"
    "nodenv"
    "openjdk@11"
    "pinentry-mac"
    "pyenv"
    "pyenv-virtualenv"
    "yarn"
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
    # Xcode = 497799835; # Pinned to 12.4.0, do _not_ use mas.
  };
  homebrew.casks = [
    "aptible"
    # "camo-studio" # need to install manually
    "docker"
    "gpg-suite"
    "hammerspoon"
    "hey"
    "kitty"
    "mos"
    "obsidian"
    "openvpn-connect"
    "postico"
    "visual-studio-code"
    "vlc"
    "yubico-authenticator"
    "yubico-yubikey-manager"
    "yubico-yubikey-personalization-gui"
  ];
}
