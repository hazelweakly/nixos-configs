with {
  pkgs = import ./nix { };
  sources = import ./nix/sources.nix;
}; {
  imports = [ ./machines/precision7740.nix ./common.nix ];

  boot.kernelModules = [ "kvm-intel" "kvm-amd" "amdgpu" ];
  boot.plymouth.logo = ./dots/Untitled.png;
  # boot.plymouth.logo = pkgs.fetchurl {
  #   url = "https://pbs.twimg.com/profile_images/499601444920496128/Fc5vigRB_400x400.png"
  # };

  environment.systemPackages = with pkgs;
    [ (import "${sources.mhnix}/configs.nix" { }).matterhorn ];

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp111s0.useDHCP = true;
  services.openvpn.servers = import ./openvpn.nix;

  system.stateVersion = "20.03";
}
