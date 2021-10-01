{ pkgs, config, inputs, ... }: {
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
    ranger
    fup-repl
    # htop
    gcc
    openssh
    xhyve
    coreutils

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

  fonts.enableFontDir = true;
  fonts.fonts = [ pkgs.opensans-ttf pkgs.victor-mono ];

  services.nix-daemon.enable = true;
  services.activate-system.enable = true;
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

  system.activationScripts.postActivation.text = ''
    printf "disabling spotlight indexing... "
    mdutil -i off -d / &> /dev/null
    mdutil -E / &> /dev/null
    echo "ok"
  '';

  programs.zsh.enable = true;
  nix.useSandbox = true;
  nix.sandboxPaths = [ "/private/tmp" "/private/var/tmp" "/usr/bin/env" ];

  homebrew.enable = true;
  homebrew.autoUpdate = true;
  homebrew.cleanup = "zap";
  homebrew.global.brewfile = true;
  homebrew.global.noLock = true;
  # sudo ln -sfn /usr/local/opt/openjdk@11/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-11.jdk
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
