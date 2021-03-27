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
}
