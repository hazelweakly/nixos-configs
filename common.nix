with { pkgs = import ./nix { }; }; {
  imports = [
    "${pkgs.sources.nixos-hardware}/common/cpu/intel"
    "${pkgs.sources.nixos-hardware}/common/pc/laptop"
    "${pkgs.sources.nixos-hardware}/common/pc/laptop/ssd"
    "${pkgs.sources.nixos-hardware}/common/pc/laptop/acpi_call.nix"
    "${pkgs.sources.home-manager}/nixos"
    ./cachix.nix
  ];

  nix.nixPath = [
    "nixpkgs=${pkgs.sources.nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs-overlays=/etc/nixos/nix/overlays-compat/"
  ];

  nix.binaryCaches = [ "https://hydra.iohk.io" ];
  nix.binaryCachePublicKeys =
    [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;

  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.hostName = "hazelweaklyeakly";
  networking.firewall.enable = false;

  console.font = "latarcyrheb-sun20";
  console.keyMap = "us";
  i18n.extraLocaleSettings.LC_ALL = "en_US.UTF-8";

  time.timeZone = "America/Los_Angeles";

  nix.trustedUsers = [ "hazel" ];

  fonts = let luxi = pkgs.callPackage ./luxi.nix { };
  in {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      corefonts
      luxi
    ];
    fontconfig.defaultFonts = {
      # Until fixed, this is installed in ~/.local/share/fonts
      monospace = [ "VictorMono Nerd Font" ];
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
    gnomeExtensions.gsconnect

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

    # Programs implicitly relied on in shell
    lsd
    bat
    fd
    ripgrep
  ];

  environment.variables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    VISUAL = "nvim";
    EDITOR = "nvim";
    MOZ_USE_XINPUT2 = "1";
  };

  programs.ssh.startAgent = true;
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };

  services.thermald.enable = true;
  services.interception-tools.enable = true;
  services.system-config-printer.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  services.fwupd.enable = true;
  services.throttled.enable = true;

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
      calibrationMatrix = ".5 0 0 0 .5 0 0 0 1";
    };

    displayManager.gdm = {
      enable = true;
      autoLogin.enable = true;
      autoLogin.user = "hazel";
      autoSuspend = false;
    };
    displayManager.setupCommands = "stty -ixon";

    desktopManager.gnome3.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      haskellPackages = pkgs.haskellPackages;
      # This breaks mod+Q to reload config
      config = ./dots/xmonad/xmonad.hs;
    };
  };

  # Need to set keyring password to blank?
  security.pam.services.gdm.enableGnomeKeyring = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;

  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    extraGroups =
      [ "wheel" "networkmanager" "tty" "video" "audio" "disk" "docker" ];
  };

  home-manager.users.hazel = import ./home.nix;

  nix.optimise.automatic = true;
  nix.autoOptimiseStore = true;
}
