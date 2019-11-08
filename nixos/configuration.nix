{ config, pkgs, ... }:

let
  hardware = fetchTarball
      https://github.com/NixOS/nixos-hardware/archive/master.tar.gz;
  unstable = fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
  moz = fetchTarball
      https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz;
  homeManager = fetchTarball
      https://github.com/rycee/home-manager/archive/master.tar.gz;
  hie = import (fetchTarball
      https://github.com/infinisil/all-hies/tarball/master) {};
  ghcide = import (fetchTarball
      https://github.com/hercules-ci/ghcide-nix/tarball/master) {};
in
{
  imports =
    [ "${hardware}/common/cpu/intel"
      "${hardware}/common/pc/ssd"
      "${hardware}/common/pc/laptop"
      "${homeManager}/nixos"
      ./cachix.nix 
      ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstable {
        config = config.nixpkgs.config;
        overlays = [ (import moz) ];
      };
    };
  };

  boot.kernelPackages = pkgs.unstable.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;

  networking.useDHCP = false;
  networking.interfaces.wlp58s0.useDHCP = true;
  networking.networkmanager.enable = true;

  i18n = {
    consoleFont = "latarcyrheb-sun20";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  time.timeZone = "America/Los_Angeles";

  nix.trustedUsers = [ "hazel" ];
  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs.unstable; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];

  environment.systemPackages = with pkgs.unstable; [
    bc
    lsd
    firefox-devedition-bin
    # Wait for https://github.com/mozilla/nixpkgs-mozilla/issues/199 to be fixed
    # latest.firefox-nightly-bin
    latest.rustChannels.nightly.rust
    git
    htop
    home-manager
    neovim
    networkmanager
    nix-index
    nix-prefetch-git
    nix-prefetch-scripts
    wget
    which
    zsh

    aspell
    aspellDicts.en

    ncurses

    yarn
    nodejs
    universal-ctags
    kitty

    cachix
    (hie.selection { selector = p: { inherit (p) ghc865; }; })
    ghcide.ghcide-ghc865

    bat
    bspwm
    chromium
    dunst
    fd
    feh
    fzf
    gcc
    ghc
    gnumake
    gnupg
    haskellPackages.turtle
    highlight
    libnotify
    libxml2
    mpv
    mupdf
    ncdu
    pandoc
    polybar
    qutebrowser
    ranger
    niv
    ripgrep
    ripgrep-all
    rofi
    scrot
    stack
    sxhkd
    texlive.combined.scheme-full
    w3m
    weechat
    zlib
    zopfli
  ];

  environment.variables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs.ssh.startAgent = true;

  services.thermald.enable = true;
  services.interception-tools.enable = true;
  services.system-config-printer.enable = true;
  services.printing.enable = true;

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    temperature = {
      day = 6500;
      night = 2300;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbVariant = "altgr-intl";

  services.xserver.libinput.naturalScrolling = true;

  services.xserver.displayManager.slim = {
    enable = true;
    autoLogin = true;
    defaultUser = "hazel";
  };

  services.xserver.desktopManager.plasma5.enable = true;

  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "tty" "video" "audio" "disk" ]; # Enable ‘sudo’ for the user.
  };

  home-manager.users.hazel = { pkgs, ... }: {

  };

  system.autoUpgrade.enable = true;
  nix.optimise.automatic = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
