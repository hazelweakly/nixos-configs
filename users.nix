{ pkgs, config, ... }: {
  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "networkmanager"
      "tty"
      "video"
      "audio"
      "disk"
      "docker"
      "libvirtd"
      "adbusers"
      "dialout"
    ];
  };

  home-manager.users.hazel = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  systemd.services.home-manager-hazel.preStart =
    "${pkgs.nix}/bin/nix-env -i -E";
}
