with { pkgs = import ./nix { }; };
let
  papis = with pkgs.python3Packages;
    (toPythonApplication (callPackage ./papis.nix { }));
in {
  imports = [
    "${pkgs.sources.nixos-hardware}/common/cpu/intel"
    "${pkgs.sources.nixos-hardware}/common/pc/laptop"
    "${pkgs.sources.nixos-hardware}/common/pc/laptop/ssd"
    "${pkgs.sources.home-manager}/nixos"
    ./cachix.nix
  ];

  nixpkgs.config = pkgs.config;
  nixpkgs.overlays = pkgs.overlays;
  nix.nixPath = [
    "nixpkgs=${pkgs.sources.nixpkgs}"
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs-overlays=/etc/nixos/nix/overlays-compat/"
  ];

  # https://bugzilla.kernel.org/buglist.cgi?bug_status=NEW&bug_status=ASSIGNED&bug_status=NEEDINFO&bug_status=REOPENED&field0-0-0=product&field0-0-1=component&field0-0-2=alias&field0-0-3=short_desc&field0-0-4=status_whiteboard&field0-0-5=content&no_redirect=1&order=changeddate%20DESC%2Cbug_status%2Cpriority%2Cassigned_to%2Cbug_id&query_format=advanced&type0-0-0=substring&type0-0-1=substring&type0-0-2=substring&type0-0-3=substring&type0-0-4=substring&type0-0-5=matches&value0-0-0=ax200&value0-0-1=ax200&value0-0-2=ax200&value0-0-3=ax200&value0-0-4=ax200&value0-0-5=%22ax200%22
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;

  networking.useDHCP = false;
  networking.hostName = "hazelweaklyeakly";
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.wifi.powersave = false;

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
    tridactyl-native
    file
    timewarrior
    mupdf
    niv
    (callPackage ./neovim.nix { })
    zoom-us
    neuron
    papis

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
    MOZ_ENABLE_WAYLAND = "1";
    LPASS_AGENT_TIMEOUT = "0";
  };

  programs.ssh.startAgent = true;
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
  programs.adb.enable = true;
  programs.gnupg.agent.enable = true;

  services.thermald.enable = true;
  services.interception-tools.enable = true;
  services.system-config-printer.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    canon-cups-ufr2
    brlaser
  ];
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
  hardware.enableAllFirmware = true;
  services.tlp.enable = true;
  hardware.opengl.enable = true;
  services.chrony.enable = true;

  services.foldingathome.enable = true;
  services.foldingathome.team = 242964;
  services.foldingathome.user = "Hazel Weakly";

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
      autoLogin.enable = false;
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
  environment.etc."docker/daemon.json".text =
    ''{ "features": { "buildkit": true } }'';

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "tty"
      "video"
      "audio"
      "disk"
      "docker"
      "libvirtd"
      "adbusers"
    ];
  };

  home-manager.users.hazel = import ./home.nix;
  systemd.services.home-manager-hazel.preStart =
    "${pkgs.nix}/bin/nix-env -i -E";

  nix.optimise.automatic = true;
}
