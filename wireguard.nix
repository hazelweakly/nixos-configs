{ pkgs, config, inputs, ... }: {

  age.secrets.wg-colo.file = ./secrets/wg-colo;
  age.secrets.wg-colo.group = "systemd-network";
  age.secrets.wg-colo.mode = "440";
  age.secrets.wg-portland.file = ./secrets/wg-portland;
  age.secrets.wg-portland.group = "systemd-network";
  age.secrets.wg-portland.mode = "440";

  environment.systemPackages = [ pkgs.wireguard-tools ];
  systemd.network = {
    enable = true;
    netdevs = {
      "10-wg0" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg0";
        };
        wireguardConfig.PrivateKeyFile = config.age.secrets.wg-colo.path;
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "9xqBm/8JNWWyfB2CG3LtETxO4LZJqvnu9HidfJXSukk=";
            AllowedIPs = [ "10.10.0.0/16" "64.16.52.128/25" ];
            Endpoint = "64.16.52.138:31194";
          };
        }];
      };
      "10-wg1" = {
        netdevConfig = {
          Kind = "wireguard";
          Name = "wg1";
        };
        wireguardConfig.PrivateKeyFile = config.age.secrets.wg-portland.path;
        wireguardPeers = [{
          wireguardPeerConfig = {
            PublicKey = "bUVmd8sOGyhFD6MKe1r3Why2WscKxNdUhBUDBVA9zUo=";
            AllowedIPs = [
              "192.168.48.0/20"
              "10.20.0.0/16"
              "65.132.32.128/25"
              "2001:428:6002:400::/56"
            ];
            Endpoint = "65.132.32.180:31194";
          };
        }];
      };
    };
    networks = let
      r = let
        wg = d: {
          routeConfig = {
            Gateway = "192.168.0.1";
            Destination = d;
            GatewayOnLink = true;
            Table = "5000";
          };
        };
      in {
        routes = [
          (wg "64.16.52.138") # wg0
          (wg "65.132.32.180") # wg1
        ];
        routingPolicyRules = [{
          routingPolicyRuleConfig = {
            From = "0.0.0.0/0";
            Table = "5000";
            Priority = 5;
          };
        }];
      };
      mkR = d: {
        routeConfig = {
          Destination = d;
          Scope = "link";
        };
      };
    in {
      "40-wg0" = {
        matchConfig.Name = "wg0";
        networkConfig.DNS = [ "10.10.10.1" ];
        networkConfig.Domains = [ "galois.com" ];
        address = [ "10.10.10.80/32" ];
        routes = map mkR [ "10.10.0.0/16" "64.16.52.128/25" ];
      };
      "40-wg1" = {
        matchConfig.Name = "wg1";
        networkConfig.DNS = [ "10.20.10.1" ];
        networkConfig.Domains = [ "galois.com" ];
        # address = [ "10.20.10.80/32" "2001:428:6002:410::80/128" ];
        address = [ "10.20.10.80/32" ];
        routes = map mkR [
          "192.168.48.0/20"
          "10.20.0.0/16"
          "65.132.32.128/25"
          "2001:428:6002:400::/56"
        ];
      };
      "40-eno1" = r;
      "40-wlan0" = r;
    };
  };
}
