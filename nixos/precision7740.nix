with {
  pkgs = import ./nix {};
  sources = import ./nix/sources.nix;
}; {
  imports = [
    ./machines/precision7740.nix
    ./common.nix
  ];

  # boot.plymouth.logo = pkgs.fetchurl {
  #   url = "https://pbs.twimg.com/profile_images/499601444920496128/Fc5vigRB_400x400.png"
  # };

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp111s0.useDHCP = true;

  system.stateVersion = "20.03";
}
