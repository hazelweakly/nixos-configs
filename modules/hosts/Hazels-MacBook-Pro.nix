{ self, inputs, ... }@args: [
  {
    networking.hostName = "Hazels-MacBook-Pro";
    environment.etc.hostname.text = ''
      Hazels-MacBook-Pro
    '';
  }
] ++ (import ./common.nix args)
