{ config, pkgs, ... }:

with builtins;
with pkgs.lib; {
  imports = [ ./caddy.nix ];
  networking.useNetworkd = true;
  services.resolved.extraConfig = "DNSStubListener=no";
  networking.nameservers = [ "127.0.0.1" "::1" ];
  services.coredns.enable = true;
  services.coredns.config = ''
    . {
        bind 127.0.0.1 ::1
        forward . 127.0.0.1:5301 127.0.0.1:5302 {
            except localhost local
        }
        local
        cache 60
    }

    .:5301 {
        forward . tls://9.9.9.9 {
            tls_servername dns.quad9.net
            health_check 5s
        }
        cache 30
    }

    .:5307 {
        forward . tls://1.1.1.1 tls://1.0.0.1 {
            tls_servername cloudflare-dns.com
            health_check 5s
        }
        cache 30
    }
  '';

  services.caddy2 = {
    enable = true;
    config = ''
      {
        admin   off
        local_certs
      }
      zk.localhost {
        encode zstd gzip
        reverse_proxy 127.53.54.1:50000
      }
      notes.localhost {
        encode zstd gzip
        reverse_proxy 127.53.54.2:50001
      }
    '';
  };
  security.pki.certificates = builtins.map builtins.readFile
    [ "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt" ];
}
