with { pkgs = import ./nix { }; };
let
  # matterhorn = pkgs.haskellPackages.developPackage {
  #   name = "matterhorn";
  #   root = pkgs.fetchgit {
  #     url = "https://github.com/matterhorn-chat/matterhorn";
  #     deepClone = true;
  #     sha256 = "0q51qk35hnxyf27hkv66z1bni7qq5sjjmlvfmdmzljwkrb1bkiwp";
  #   };
  #   overrides = self: super:
  #     with pkgs.haskell.lib; {
  #       # mattermost-api = dontCheck super.mattermost-api;
  #       Unique = unmarkBroken (dontCheck super.Unique);
  #     };
  # };
in {
  imports = [ ./machines/precision7740.nix ./common.nix ./work.nix ];

  boot.plymouth.logo = ./dots/galois.png;

  # environment.systemPackages = [ matterhorn ];

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp111s0.useDHCP = true;
  services.openvpn.servers = import ./openvpn.nix;
  environment.etc."systemd/sleep.conf".text = ''
    AllowHibernation=no
    SuspendState=freeze
  '';

  system.stateVersion = "20.03";
}
