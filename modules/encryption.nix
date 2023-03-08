{ pkgs, lib, inputs, self, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    environment.systemPackages = [ pkgs.sbctl pkgs.cryptsetup ];

    boot.bootspec.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.secureboot = {
      enable = true;
      signingKeyPath = "/etc/secureboot/keys/db/db.key";
      signingCertPath = "/etc/secureboot/keys/db/db.pem";
    };

    boot.initrd.luks.devices."crypto-root".crypttabExtraOpts = [
      "tmp2-device=auto"
    ];
    boot.initrd.systemd.enable = true;

    security.tpm2.enable = true;
    security.tpm2.pkcs11.enable = true;

  })
]
