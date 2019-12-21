with {
  pkgs = import ./nix { };
  sources = import ./nix/sources.nix;
}; {
  imports = [
    "${sources.nixos-hardware}/common/cpu/intel"
    "${sources.nixos-hardware}/common/pc/ssd"
    "${sources.nixos-hardware}/common/pc/laptop"
    "${sources.home-manager}/nixos"
    ./cachix.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;

  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.hostName = "hazelweaklyeakly";
  networking.firewall.enable = false;

  i18n = {
    consoleFont = "latarcyrheb-sun20";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  time.timeZone = "America/Los_Angeles";

  nix.trustedUsers = [ "hazel" ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ noto-fonts noto-fonts-cjk noto-fonts-emoji ];
    fontconfig.defaultFonts = {
      monospace = [ "PragmataPro" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  environment.systemPackages = with pkgs; [
    # Actually global
    lastpass-cli
    google-chrome
    calibre
    kitty
    cachix

    # Stuff relied on by my nvim configs
    neovim-remote
    nodePackages.neovim
    python37Packages.pynvim
    python3
    ((neovim.override { withNodeJs = true; }).passthru.unwrapped.overrideAttrs
      (o: {
        version = "master";
        src = sources.neovim;
        buildInputs = o.buildInputs ++ [ utf8proc ];
      }))
    nixfmt
    yarn
    nodejs_latest
    universal-ctags

    # ncurses

    # ((import sources.all-hies { }).selection {
    #   selector = p: { inherit (p) ghc865; };
    # })
    # (import sources.ghcide-nix { }).ghcide-ghc865

    # Programs implicitly relied on in shell
    lsd
    bat
    fd
    fzf
    ripgrep
  ];

  environment.variables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    VISUAL = "nvim";
    EDITOR = "nvim";
    # Scroll with a toushcreen in firefox
    MOZ_USE_XINPUT2 = "1";
    # Relied on by my nvim configs
    # RUST_SRC_PATH = "${
    #     (pkgs.latest.rustChannels.nightly.rust.override {
    #       extensions = [ "rust-src" ];
    #     })
    #   }/lib/rustlib/src/rust/src";
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
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

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

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    autoRepeatDelay = 190;
    autoRepeatInterval = 35;

    libinput = {
      naturalScrolling = true;
      disableWhileTyping = true;
      accelSpeed = "0.5";
      tapping = true;
      calibrationMatrix = ".5 0 0 0 .5 0 0 0 1";
    };

    displayManager.gdm = {
      enable = true;
      wayland = false;
      # autoLogin = {
      #   enable = true;
      #   user = "hazel";
      # };
    };

    desktopManager.gnome3 = {
      enable = true;
      flashback.enableMetacity = true;
      flashback.customSessions = [
        {
          wmLabel = "XMonad";
          wmCommand = "${pkgs.xmonad-with-packages}/bin/xmonad";
          wmName = "xmonad";
        }
        {
          wmLabel = "META";
          wmCommand = "${pkgs.gnome3.metacity}/bin/metacity";
          wmName = "metacity";
        }
      ];
    };
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      haskellPackages = pkgs.haskellPackages;
    };
    windowManager.default = "xmonad";

    # TODO: Figure out how to get this done with
    # keeping plasma because I'll lose too much time replicating plasma's setup
    # wrt stuff like NetworkManager, printer, etc. *sigh* whatevs. The
    # convenience is worth losing some street cred I suppose.

    # desktopManager.default = "none";
    # desktopManager.xterm.enable = false;
    # windowManager.default = "xmonad";
    # windowManager.xmonad = {
    #   enable = true;
    #   enableContribAndExtras = true;
    #   haskellPackages = pkgs.unstable.haskellPackages;
    #   config = /home/hazel/.config/xmonad/xmonad.hs;
    # };
    # displayManager.sessionCommands = lib.mkAfter ''
    #   ${pkgs.unstable.xorg.xset}/bin/xset r rate 240 30
    # '';

  };

  virtualisation.docker.enable = true;

  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    extraGroups =
      [ "wheel" "networkmanager" "tty" "video" "audio" "disk" "docker" ];
  };

  home-manager.users.hazel = import ./home.nix;

  system.autoUpgrade.enable = true;
  nix.optimise.automatic = true;
}
