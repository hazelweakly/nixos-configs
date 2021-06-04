{ pkgs, config, ... }: {
  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    initialHashedPassword = "$6$TSyriaI0RRg$5XyFOc5pCQXVtb/W9AnT27wV192QlFQuYP85AC7vzOjfVV91qkC.qBj1mxeJODO.LFHKdRm/tCjefU5GhShF60";
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
  users.users.root = {
    initialHashedPassword = "$6$fApwBml5yZCA$0RFzkpi/W.yjZ/sq5CDmsWnysl5NyGkIpKZbcCVkslhs/itPjgwLHeEP69hc.0T3Z049LrEg7oUH46l55tivl0";
  };
}
