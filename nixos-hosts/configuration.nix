{ config, pkgs, ... }: {
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  imports = [
    ./hardware-configuration.nix
  ];

  console.font = "latarcyrheb-sun32";
  console.keyMap = "us";

  programs.ssh.startAgent = true;
  # services.thermald.enable = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  location.provider = "geoclue2";
  # breaks secureboot thingy?
  # services.fwupd.enable = true;
  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true;

  # recommended settings from lxd nixos module
  boot.kernel.sysctl = {
    "fs.inotify.max_queued_events" = 1048576;
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
    "vm.max_map_count" = 262144;
    "kernel.dmesg_restrict" = 1;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv6.neigh.default.gc_thresh3" = 8192;
    "kernel.keys.maxkeys" = 2000;
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.tmpOnTmpfs = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # # Setup keyfile
  # boot.initrd.secrets = {
  #   "/crypto_keyfile.bin" = null;
  # };

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;

  time.timeZone = "America/Los_Angeles";

  services.xserver.layout = "us";
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.middleEmulation = true;
  services.xserver.libinput.touchpad.tapping = true;

  services.xserver.xkbVariant = "altgr-intl";
  services.xserver.autoRepeatDelay = 190;
  services.xserver.autoRepeatInterval = 35;

  services.xserver.libinput.touchpad.naturalScrolling = true;
  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.accelSpeed = "0.5";
  services.xserver.libinput.touchpad.calibrationMatrix = ".5 0 0 0 .5 0 0 0 1";

  # services.xserver.displayManager.setupCommands = ''
  #   stty -ixon
  # '';

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; with pkgs.gnome3; [
    gnome-photos
    gnome-tour
    gnome-music
    gnome-terminal
    cheese
    epiphany
    geary
    gedit
    tali
    iagno
    hitori
    atomix
  ];
  programs.dconf.enable = true;
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.hazel = {
    isNormalUser = true;
    description = "Hazel Weakly";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  boot.plymouth.enable = true;
  boot.kernelParams = [ "quiet" "splash" ];
  boot.consoleLogLevel = 0;
  boot.initrd.verbose = false;
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [ "aesni_intel" ];

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "22.11"; # Did you read the comment?
}
