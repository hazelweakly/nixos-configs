{ pkgs, lib, config, systemProfile, userProfile, modulesPath, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    # doesn't work under secure boot yet
    # https://github.com/nix-community/lanzaboote/pull/119
    # https://github.com/NixOS/rfcs/pull/125
    # services.fwupd.enable = true;

    boot.initrd.availableKernelModules = [ "aesni_intel" "xhci_pci" "nvme" "thunderbolt" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    boot.kernelModules = [ "kvm-intel" ];

    zramSwap.enable = true;
    zramSwap.memoryPercent = 25;
    services.earlyoom.enable = true;
    services.earlyoom.freeMemThreshold = 5;
    services.earlyoom.freeSwapThreshold = 2;
    services.earlyoom.enableNotifications = true;
    services.earlyoom.extraArgs = [
      "--prefer '^(Web Content|.haskell-langua|ghc|ghcid|.cabal-wrapped)$'" # fuck hls. all my homies hate hls. (actually i luv it, it just sux ram like its tryna do a run on a ram bank)
      "--avoid '^(gnome.*|\.gnome.*|gdm|gdm-.*|Xwayland|systemd|systemd-.*|dbus-.*|ssh|\.gsd-.*)$'"
    ];

    boot.plymouth.enable = true;
    boot.kernelParams = [ "quiet" "splash" ];
    boot.consoleLogLevel = 0;
    boot.initrd.verbose = false;
    boot.initrd.systemd.enable = true;

    boot.kernelPackages = pkgs.linuxPackages_latest;

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
    boot.tmp.useTmpfs = true;
    boot.loader.timeout = 0;
    boot.loader.systemd-boot.configurationLimit = 10;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    fileSystems."/" = {
      device = "/dev/disk/by-label/root";
      fsType = "ext4";
    };

    boot.initrd.luks.devices."crypto-root".device = "/dev/disk/by-label/crypto-root";

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

    swapDevices = [ ];

    powerManagement.enable = false;

    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  })
] // lib.optionalAttrs systemProfile.isLinux {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
}

