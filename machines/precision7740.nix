{ pkgs, ... }:
let sources = import ../nix/sources.nix;
in {
  imports =
    [ (sources.nixpkgs + "/nixos/modules/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules =
    [ "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];

  # services.xserver.videoDrivers = [ "modesetting" ];
  # boot.kernelParams = [ "i915.modeset=1" "i915.fastboot=1" ];
  # boot.blacklistedKernelModules = [ "nouveau" ];
  # services.udev.extraRules = ''
  #   #Remove NVIDIA USB xHCI Host Controller Devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{remove}=="1"
  #   #Remove NVIDIA USB Type-C UCSI devices, if present
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de" , ATTR{class}=="0x0c8000", ATTR{remove}=="1"
  #   #Remove NVIDIA Audio Devices
  #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{remove}=="1"
  #   #enable pci port kernel power management
  #   SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", ATTR{power/control}=="auto"
  #   SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030200", ATTR{power/control}=="auto"
  # '';
  # systemd.services.yolo-nvidia = {
  #   after = [ "sysinit.target" ];
  #   serviceConfig.Type = "oneshot";
  #   serviceConfig.RemainAfterExit = "yes";
  #   serviceConfig.ExecStart = ''
  #     /bin/sh -c "echo 1 > /sys/bus/pci/devices/0000:01:00.0/remove; echo '\\_SB.PCI0.PEG0.PEGP._OFF' >     /proc/acpi/call || true"'';
  #   serviceConfig.ExecStop = ''
  #     /bin/sh -c "echo '\\_SB.PCI0.PEG0.PEGP._ON' > /proc/acpi/call; echo 1 > /sys/bus/pci/rescan || true"'';
  #   wantedBy = [ "sysinit.target" ];
  # };

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

  services.interception-tools.enable = false;
  services.plex = {
    enable = true;
    openFirewall = true;
  };

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;
  services.openvpn.servers = {
    galois-onsite = {
      autoStart = false;
      config = "config /root/vpn/hweakly_onsite.ovpn";
      down = ''
        ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
        ${pkgs.procps}/bin/pkill --signal SIGUSR1 coredns
      '';
      up = ''
        ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
        ${pkgs.procps}/bin/pkill --signal SIGUSR1 coredns
      '';
    };
    galois-offsite = {
      autoStart = false;
      config = "config /root/vpn/hweakly_offsite.ovpn";
      down = ''
        ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
        ${pkgs.procps}/bin/pkill --signal SIGUSR1 coredns
      '';
      up = ''
        ${pkgs.update-systemd-resolved}/libexec/openvpn/update-systemd-resolved
        ${pkgs.procps}/bin/pkill --signal SIGUSR1 coredns
      '';
    };
  };
  systemd.services.openvpn-galois-offsite.after = [ "network-online.target" ];
  systemd.services.openvpn-galois-onsite.after = [ "network-online.target" ];
  system.stateVersion = "20.09";
}
