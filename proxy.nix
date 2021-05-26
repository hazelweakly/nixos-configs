{ config, pkgs, ... }:

with builtins;
with pkgs.lib; {
  # https://caddy.community/t/how-to-setup-a-custom-caddy-pki-and-acme-server-with-an-existing-ca/11683
  imports = [ ./caddy.nix ];
  services.coredns.enable = true;
  services.coredns.config = ''
    . {
        bind 127.0.0.1
        forward . 127.0.0.1:5301 127.0.0.1:5302 127.0.0.1:5303 {
            except localhost local
        }
        local
    }

    .:5301 {
        loadbalance round_robin
        forward . tls://9.9.9.9 tls://149.112.112.112 {
            tls_servername dns.quad9.net
            health_check 90s
        }
        cache 60
    }

    .:5302 {
        loadbalance round_robin
        forward . tls://8.8.8.8 tls://8.8.4.4 {
            tls_servername dns.google
            health_check 90s
        }
        cache 60
    }

    .:5303 {
        forward . 10.20.10.1 10.10.10.1 {
            health_check 3600s
        }
        cache 5s
    }
  '';

  services.caddy2 = {
    enable = true;
    config = ''
      {
        admin   off
        local_certs
        servers :443 {
          protocol {
            experimental_http3
          }
        }
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
  # Currently has a bootstrapping problem. Caddy needs to exist and then this can be uncommented and ran
  # https://discourse.nixos.org/t/getting-firefox-to-work-with-p11-kit-to-use-system-wide-installed-certificates/3175
  # p11-trust already des the system config now
  # just need to add ${pkgs.p11-kit}/lib/pkcs11/p11-kit-trust.so to firefox as a security device
  # for chrome:
  # - ln -sf ${pkgs.p11-kit}/lib/pkcs11/p11-kit-trust.so ~/.pki/nssdb/libnssckbi.so
  # in ~/.pki/nssdb/pkcs11.txt:
  #
  # library=/home/hazel/.pki/nssdb/libnssckbi.so
  # name=Root Certs
  # NSS=trustOrder=100    

  # "/var/lib/caddy/.local/share/caddy/pki/authorities/local/root.crt"
  # for now I copied this file to the root.crt file and it's an ugly hack. Whatevs
  security.pki.certificateFiles = [ ./root.crt ];
}
