{ self, inputs, ... }@args: [
  {
    networking.hostName = "Eden-C02GR3NTQ05N";
    environment.etc.hostname.text = ''
      Eden-C02GR3NTQ05N
    '';
  }
] ++ (import ./common.nix args)
