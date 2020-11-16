{ pkgs ? import ./nix { }, ... }:
let sources = import ./nix/sources.nix;
in {
  imports = [
    (sources.nixos-hardware + "/common/cpu/intel")
    (sources.nixos-hardware + "/common/pc/laptop")
    (sources.nixos-hardware + "/common/pc/laptop/ssd")
    (sources.home-manager + "/nixos")
    ./cachix.nix
    ./env.nix
    ./dyn-wp.nix
    ./foldingathome.nix
  ];

  nixpkgs.config = import ./nix/config.nix;
  nixpkgs.overlays = import ./nix/overlays.nix { inherit sources; };
  nix.nixPath = [
    ("nixpkgs=" + builtins.toString sources.nixpkgs)
    "nixos-config=/etc/nixos/configuration.nix"
    "nixpkgs-overlays=/etc/nixos/nix/overlays-compat/"
  ];
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_5_8;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 50;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.useDHCP = false;
  networking.hostName = "hazelweaklyeakly";
  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

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

  environment.systemPackages = with pkgs;
    let
      p = mach-nix.mkPython { requirements = "papis-zotero"; };
      papis-exts = stdenv.mkDerivation {
        name = "papis-exts";
        src = "";
        phases = [ "buildPhase" ];
        buildPhase = ''
          sp=lib/${p.executable}/site-packages; mkdir -p $out/bin $out/$sp
          for e in ${p.outPath}/bin/papis-*; do ln -s $e $out/bin; done
          for l in ${p.outPath}/$sp/{papis_*,zotero}; do ln -s $l $out/$sp; done
        '';
      };
    in [
      # Actually global
      lastpass-cli
      google-chrome
      kitty
      cachix
      tridactyl-native
      file
      timewarrior
      taskwarrior
      mupdf
      niv
      (callPackage ./neovim.nix { })
      zoom-us
      neuron
      obelisk.command
      (callPackage ./awscli2.nix { })
      ssm-session-manager-plugin
      alacritty
      ranger
      mach-nix.mach-nix
      networkmanager-openvpn
      papis
      papis-exts

      # Programs implicitly relied on in shell
      exa
      gitAndTools.delta
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
  services.interception-tools.enable = pkgs.lib.mkDefault true;
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
  # services.fwupd.enable = true;
  services.throttled.enable = true;

  location.provider = "geoclue2";
  services.redshift = {
    enable = false;
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

    displayManager.autoLogin.enable = false;
    displayManager.autoLogin.user = "hazel";
    displayManager.gdm = {
      enable = true;
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

  environment.etc.zoneinfo.source = pkgs.lib.mkForce "${
      pkgs.tzdata.overrideAttrs (old: {
        makeFlags = old.makeFlags
          ++ [ ''CFLAGS+=-DZIC_BLOAT_DEFAULT=\"fat\"'' ];
      })
    }/share/zoneinfo";

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  nix.optimise.automatic = true;
}
