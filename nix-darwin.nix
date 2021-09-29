{ pkgs, config, ... }: {
  environment.systemPackages = with pkgs; [
    # kitty
    terminal-notifier
    curl
    gitAndTools.gitFull
    git-lfs
    cachix
    file
    timewarrior
    taskwarrior
    tasksh
    (callPackage ./neovim.nix { })
    ranger
    fup-repl
    htop
    gcc
    openssh

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

  fonts.enableFontDir = true;
  fonts.fonts = [ pkgs.opensans-ttf pkgs.victor-mono ];

  services.nix-daemon.enable = true;
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = 4;
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes ca-references
  '';

  system.defaults.NSGlobalDomain = {
    AppleShowScrollBars = "Automatic";
    InitialKeyRepeat = 15;
    KeyRepeat = 2;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
  };

  system.defaults.dock = {
    autohide = true;
    expose-group-by-app = true;
    mru-spaces = true;
    tilesize = 32;
  };

  programs.zsh.enable = true;

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  # sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
  homebrew.brews = [
    "openjdk@11"
    "pyenv"
    "pyenv-virtualenv"
    "nodenv"
    "node"
    "yarn"
    "cocoapods"
    "clj-kondo"
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
    "camo-studio"
    "gpg-suite"
    "hammerspoon"
    "hey"
    "mos"
    "obsidian"
    "postico"
    "visual-studio-code"
    "vlc"
    "yubico-yubikey-manager"
    "yubico-yubikey-personalization-gui"
  ];
}
