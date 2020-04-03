{ config, ... }:
let
  pkgs = import ../nix { };
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
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

  environment.systemPackages = [ nvidia-offload ];
  boot.blacklistedKernelModules = [ "nouveau" ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime.offload.enable = true;
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart =
      "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi";
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
