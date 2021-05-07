{ pkgs, config, inputs, ... }: {

  networking.firewall.enable = false;
  networking.networkmanager.enable = true; # default true cause gnome
  networking.networkmanager.wifi.backend = "iwd";
  networking.nameservers = [ "127.0.0.1" ]; # avoid ipv6 cause centurylink
  networking.useNetworkd = true;

  services.resolved.extraConfig = "DNSStubListener=no";

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlan0.useDHCP = true;

  systemd.services.systemd-networkd-wait-online.serviceConfig.ExecStart =
    [ "" "${pkgs.systemd}/lib/systemd/systemd-networkd-wait-online --any" ];

}
