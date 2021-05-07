{ pkgs, config, ... }: {
  boot.initrd.availableKernelModules =
    [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3a04d1d9-61d7-4ae6-83bb-1f5eb33c37aa";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2511-C8B6";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/fd907341-24b5-4d9c-95c0-62837f7d4501"; }];

  nix.maxJobs = pkgs.lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = pkgs.lib.mkDefault "powersave";

  system.stateVersion = "19.09";
}
