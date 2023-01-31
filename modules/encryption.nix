{ pkgs, lib, inputs, self, ... }: {
  environment.systemPackages = [ pkgs.sbctl pkgs.cryptsetup ];

  boot.bootspec.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.secureboot = {
    enable = true;
    signingKeyPath = "/etc/secureboot/keys/db/db.key";
    signingCertPath = "/etc/secureboot/keys/db/db.pem";
  };

  boot.initrd.luks.devices."luks-1ac9712b-5da2-4e68-b647-bd7bb9a2e6be".crypttabExtraOpts = [
    "tmp2-device=auto"
  ];
  boot.initrd.systemd.enable = true;
}
