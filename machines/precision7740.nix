{ pkgs, config, ... }: {
  boot.initrd.availableKernelModules =
    [ "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" "acpi_call" ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Pointer disable physical button of pointer]
    MatchName=DELL0927:00 044E:1220 Mouse
    AttrEventCodeDisable=BTN_LEFT;BTN_MIDDLE;BTN_RIGHT

    [Touchpad disable physical button of touchpad]
    MatchUdevType=touchpad
    MatchName=DELL0927:00 044E:1220 Touchpad
    AttrEventCodeDisable=BTN_LEFT;BTN_MIDDLE;BTN_RIGHT
  '';

  # https://unix.stackexchange.com/questions/228988/how-to-automatically-disable-laptop-keyboard-mouse-with-xinput-when-external-key
  # The true solution is eventually: https://bbs.archlinux.org/viewtopic.php?pid=1626055#p1626055
  services.udev.extraRules = let
    run = pkgs.writeShellScript "run" ''
      set +e
      set -x
      sleep 1
      export PATH=${pkgs.lib.makeBinPath [ pkgs.xorg.xinput ]}:$PATH
      echo "hi there" > /tmp/debug-udev
      date >> /tmp/debug-udev
      env >> /tmp/debug-udev
      if [[ "$ACTION" == "add" ]]; then cmd="--disable"; else cmd="--enable"; fi
      devices="$(xinput list)"
      echo "doing the thing" >> /tmp/debug-udev
      echo "$devices" >> /tmp/debug-udev
      get_id() { grep "$1" <<< "$devices" | cut -d= -f2 | cut -f1; }
      for device in 'DELL0927:00 044E:1220 Mouse' 'AT Translated Set 2 keyboard' 'Virtual core XTEST pointer'; do
        echo xinput "$cmd" "$(get_id "$device")" >> /tmp/debug-udev
        xinput "$cmd" "$(get_id "$device")" || true
      done
      echo "done" >> /tmp/debug-udev
    '';
  in ''
    # ATTRS{idProduct}=="6060", SYMLINK+="chimera"
    # ATTRS{idProduct}=="6060", RUN+="${pkgs.bash}/bin/bash -c 'touch /tmp/y-tho ; env >> /tmp/y-tho'"
    ACTION=="add|remove", ENV{ID_MODEL_ID}=="6060", ENV{ID_VENDOR_ID}="feed", SYMLINK+="chimera"
    ACTION=="add|remove", ENV{ID_MODEL_ID}=="6060", ENV{ID_VENDOR_ID}="feed", RUN+="${pkgs.bash}/bin/bash -c 'touch /tmp/y-tho ; env >> /tmp/y-tho; ${run} &'"
  '';

  services.xserver.videoDrivers = [ "nvidia" ];
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
    enable = false;
    openFirewall = true;
  };
  system.stateVersion = "20.09";
}
