with { pkgs = import ./nix { }; }; {
  imports = [ ./machines/xps9350.nix ./common.nix ];

  networking.interfaces.wlp58s0.useDHCP = true;

  system.stateVersion = "19.09";
}
