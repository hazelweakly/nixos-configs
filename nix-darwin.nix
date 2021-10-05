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
  services.activate-system.enable = true;
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

  system.activationScripts.postActivation.text = builtins.concatStringsSep "\n" [
    ''
      printf "disabling spotlight indexing... "
      mdutil -i off -d / &> /dev/null
      mdutil -E / &> /dev/null
      echo "ok"
    ''
    config.system.activationScripts.pam.text # temp hack
  ];

  launchd.user.agents.dark-mode-notify = {
    environment.PATH = "/bin:/usr/bin:${pkgs.lib.makeBinPath [switch-theme pkgs.neovim-remote]}";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = "hazelweakly";
      GroupName = "staff";
      StandardOutPath = "/tmp/dark-mode-notify.stdout";
      StandardErrorPath = "/tmp/dark-mode-notify.stderr";
    };
    command = "${./dark-mode-notify.swift} ${switch-theme}";
  };

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
