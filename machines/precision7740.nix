with { pkgs = import ../nix { }; }; {
  imports =
    [ "${pkgs.sources.nixpkgs}/nixos/modules/installer/scan/not-detected.nix" ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d9bedf23-52c0-43d1-a03d-27d0302363b1";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/a68a8df4-413e-4004-bd35-99f56ee3fc8f";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2559-5058";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nix.maxJobs = pkgs.lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = pkgs.lib.mkDefault "powersave";
}
