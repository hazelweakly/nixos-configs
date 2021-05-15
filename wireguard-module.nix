{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.wg;

  netdevOpts = { ... }: {
    options = {
      name.type = types.str;
      privateKeyFile.type = types.str;
      publicKey.type = types.str;
      allowedIPs.type = types.listOf types.str;
      endpoint.type = types.str;
      endpointPort.type = types.str;
    };
  };

  networkOpts = { ... }: {
    options = {
      destination.type = types.str;
      gateway.type = types.str;
      publicKey.type = types.str;
      allowedIPs.type = types.listOf types.str;
      endpoint.type = types.str;
    };
  };

  mkNetDev = ndOpt: { };

in {
  options.services.wg = {
    enable = mkEnableOption "Wireguard setup with systemd-networkd";

    devices = mkOption {

    };

    config = mkOption {
      default = "";
      example = ''
        example.com {
          encode gzip
          log
          root /srv/http
        }
      '';
      type = types.lines;
      description = ''
        Verbatim Caddyfile to use.
        Caddy v2 supports multiple config formats via adapters (see <option>services.caddy.adapter</option>).
      '';
    };

    adapter = mkOption {
      default = "caddyfile";
      example = "nginx";
      type = types.str;
      description = ''
        Name of the config adapter to use.
        See https://caddyserver.com/docs/config-adapters for the full list.
      '';
    };

    ca = mkOption {
      default = "https://acme-v02.api.letsencrypt.org/directory";
      example = "https://acme-staging-v02.api.letsencrypt.org/directory";
      type = types.str;
      description =
        "Certificate authority ACME server. The default (Let's Encrypt production server) should be fine for most people.";
    };

    email = mkOption {
      default = "";
      type = types.str;
      description = "Email address (for Let's Encrypt certificate)";
    };

    dataDir = mkOption {
      default = "/var/lib/caddy";
      type = types.path;
      description = ''
        The data directory, for storing certificates. Before 17.09, this
        would create a .caddy directory. With 17.09 the contents of the
        .caddy directory are in the specified data directory instead.

        Caddy v2 replaced CADDYPATH with XDG directories.
        See https://caddyserver.com/docs/conventions#file-locations.
      '';
    };

    package = mkOption {
      default = pkgs.caddy;
      defaultText = "pkgs.caddy";
      example = "pkgs.caddy";
      type = types.package;
      description = ''
        Caddy package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
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

  };
}

