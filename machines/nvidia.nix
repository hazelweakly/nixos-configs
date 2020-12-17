{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in with pkgs.lib; {
  environment.systemPackages = [ nvidia-offload ];
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.prime.offload.enable = true;
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";
  hardware.nvidia.nvidiaPersistenced = false;
  hardware.nvidia.powerManagement.enable = true;
  services.xserver.displayManager.gdm.nvidiaWayland = true;

  # https://github.com/NixOS/nixpkgs/pull/73530

  # TODO: Figure out why this is needed and whether or not it harms battery life

  systemd.services.nvidia-control-devices = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.ExecStart =
      "${config.boot.kernelPackages.nvidia_x11.bin}/bin/nvidia-smi";
  };
}
