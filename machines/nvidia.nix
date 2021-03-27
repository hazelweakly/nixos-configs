{ config, pkgs, ... }:
with pkgs.lib; {
  hardware.nvidia.prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.prime.nvidiaBusId = "PCI:1:0:0";
}
