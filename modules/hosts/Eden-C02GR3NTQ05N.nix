{ self, inputs, ... }: [
  ./common.nix
  {
    networking.hostName = "Eden-C02GR3NTQ05N";
    environment.etc.hostname.text = ''
      Eden-C02GR3NTQ05N
    '';
  }
]
