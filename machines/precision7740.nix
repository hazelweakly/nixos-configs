let pkgs = import ../nix { };
in {
  imports =
    [ "${pkgs.sources.nixpkgs}/nixos/modules/installer/scan/not-detected.nix" ];

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/892530c7-1d95-4e13-853f-f9f00aebdc17";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."root".device =
    "/dev/disk/by-uuid/655aa5e7-3a95-44c1-8af6-337aa3127343";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/8F7B-1633";
    fsType = "vfat";
  };

  nix.maxJobs = pkgs.lib.mkDefault 16;
  powerManagement.cpuFreqGovernor = pkgs.lib.mkDefault "powersave";

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;
  services.openvpn.servers = {
    galois-onsite = {
      autoStart = false;
      config = "config /root/vpn/hweakly_onsite.ovpn";
      updateResolvConf = true;
    };
    galois-offsite = {
      config = "config /root/vpn/hweakly_offsite.ovpn";
      updateResolvConf = true;
    };
  };
  systemd.services.openvpn-galois-offsite.after = [ "network-online.target" ];
  systemd.services.openvpn-galois-onsite.after = [ "network-online.target" ];
  system.stateVersion = "20.09";
}
