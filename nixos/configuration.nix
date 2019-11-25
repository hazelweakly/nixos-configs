{ config, pkgs, ... }:

let
  hardware = fetchTarball
    "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
  unstable = fetchTarball
    "https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz";
  moz = fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz";
  homeManager =
    fetchTarball "https://github.com/rycee/home-manager/archive/master.tar.gz";
  hie =
    import (fetchTarball "https://github.com/infinisil/all-hies/tarball/master")
    { };
  ghcide = import
    (fetchTarball "https://github.com/hercules-ci/ghcide-nix/tarball/master")
    { };
in {
  imports = [
    ./hardware-configuration.nix
    "${hardware}/common/cpu/intel"
    "${hardware}/common/pc/ssd"
    "${hardware}/common/pc/laptop"
    "${homeManager}/nixos"
    ./cachix.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      unstable = import unstable {
        config = config.nixpkgs.config;
        overlays = [ (import moz) (import "${moz}/rust-src-overlay.nix") ];
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

  fonts = {
    fonts = with pkgs.unstable; [
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

    fontconfig.penultimate.enable = true;
    fontconfig.useEmbeddedBitmaps = true;
  };

  # Eventually most of this will migrate to home-manager
  # There exists a natural tension between home-manager and configuration.nix
  # where both want to manage everything if they can but I'd like to have as
  # much of my config work with root and sudo as possible (eg neovim plugins,
  # zsh, etc)
  # I think the best way forward for that will to be to pull the home-manager
  # stuff out to a couple different files and import the common stuff into a
  # users.root as well
  environment.systemPackages = with pkgs.unstable; [
    bc
    lsd
    lastpass-cli
    google-chrome
    firefox-devedition-bin
    # Wait for https://github.com/mozilla/nixpkgs-mozilla/issues/199 to be fixed
    # latest.firefox-nightly-bin
    latest.rustChannels.nightly.rust
    binutils.bintools
    git
    htop
    home-manager
    neovim
    networkmanager
    nix-index
    wget
    which
    zsh
    nixfmt

    aspell
    aspellDicts.en

    ncurses

    yarn
    nodejs-13_x
    nodePackages.node2nix
    universal-ctags
    kitty

    cachix
    (hie.selection { selector = p: { inherit (p) ghc865; }; })
    ghcide.ghcide-ghc865
    haskellPackages.turtle
    haskellPackages.hoogle
    cabal2nix
    nix-prefetch-git
    nix-prefetch-scripts
    cabal-install
    direnv

    python3
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
    # stack2nix
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
    # Scroll with a toushcreen in firefox
    MOZ_USE_XINPUT2 = "1";
    RUST_SRC_PATH = "${
        (pkgs.unstable.latest.rustChannels.nightly.rust.override {
          extensions = [ "rust-src" ];
        })
      }/lib/rustlib/src/rust/src";
  };

  programs.ssh.startAgent = true;
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    promptInit = "";
  };

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

  services.xserver.libinput = {
    naturalScrolling = true;
    disableWhileTyping = true;
    accelSpeed = "0.5";
  };

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
    extraGroups = [ "wheel" "networkmanager" "tty" "video" "audio" "disk" ];
  };

  # Use pkgs from system closure by ignoring input args
  home-manager.users.hazel = { ... }:
    let
      lorri = import (fetchTarball {
        url = "https://github.com/target/lorri/archive/rolling-release.tar.gz";
      }) { };

      path = with pkgs.unstable;
        lib.makeSearchPath "bin" [ nix gnutar git mercurial ];
    in {

      home.packages = [ lorri ];

      programs.git = {
        enable = true;
        userName = "hazelweakly";
        userEmail = "hazel@theweaklys.com";
        package = pkgs.gitAndTools.gitFull;
        extraConfig = {
          core = { pager = "diff-so-fancy | less --tabs=4 -RFX"; };
          color = {
            ui = true;
            diff-highlight = {
              oldNormal = "red bold";
              oldHighlight = "red bold 52";
              newNormal = "green bold";
              newHighlight = "green bold 22";
            };
            diff = {
              meta = "11";
              frag = "magenta bold";
              commit = "yellow bold";
              old = "red bold";
              new = "green bold";
              whitespace = "red reverse";
            };
          };
        };
      };

      systemd.user.sockets.lorri = {
        Unit = { Description = "lorri build daemon"; };
        Socket = { ListenStream = "%t/lorri/daemon.socket"; };
        Install = { WantedBy = [ "sockets.target" ]; };
      };

      systemd.user.services.lorri = {
        Unit = {
          Description = "lorri build daemon";
          Documentation = "https://github.com/target/lorri";
          ConditionUser = "!@system";
          Requires = "lorri.socket";
          After = "lorri.socket";
          RefuseManualStart = true;
        };

        Service = {
          ExecStart = "${lorri}/bin/lorri daemon";
          PrivateTmp = true;
          ProtectSystem = "strict";
          WorkingDirectory = "%h";
          Restart = "on-failure";
          Environment = "PATH=${path} RUST_BACKTRACE=1";
        };
      };
    };

  system.autoUpgrade.enable = true;
  nix.optimise.automatic = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}
