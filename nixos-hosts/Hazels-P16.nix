{
  system = "x86_64-linux";
  modules = [
    { networking.hostName = "Hazels-P16"; }
    {
      imports = [ ./hardware-configuration.nix ./configuration.nix ../modules/encryption.nix ];
    }
  ];
}
