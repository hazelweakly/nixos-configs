{ lib, config, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    services.tailscale.enable = true;
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    systemd.services.NetworkManager-wait-online.enable = false;
  })
]
