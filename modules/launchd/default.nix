{ pkgs, config, ... }: {
  launchd.user.agents.dark-mode-notify = {
    path = [ pkgs.dark-mode-notify pkgs.switch-theme pkgs.neovim-remote config.environment.systemPath ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = "hazelweakly";
      GroupName = "staff";
      StandardOutPath = "/tmp/dark-mode-notify.stdout";
      StandardErrorPath = "/tmp/dark-mode-notify.stderr";
    };
    command = "dark-mode-notify switch-theme";
  };

  launchd.user.agents.blackd = {
    path = [ pkgs.black ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = "hazelweakly";
      GroupName = "staff";
      StandardOutPath = "/tmp/blackd.stdout";
      StandardErrorPath = "/tmp/blackd.stderr";
    };
    command = "blackd";
  };

  launchd.user.agents.isortd = {
    path = [ pkgs.isortd ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = "hazelweakly";
      GroupName = "staff";
      StandardOutPath = "/tmp/isortd.stdout";
      StandardErrorPath = "/tmp/isortd.stderr";
    };
    command = "isortd";
  };

  # TODO: too much effort to rewrite the whole thing to not daemon fork.
  # launchd.user.agents.prettierd = {
  #   path = [ pkgs.myNodePackages pkgs.nodejs ];
  #   serviceConfig = {
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #     UserName = "hazelweakly";
  #     GroupName = "staff";
  #     StandardOutPath = "/tmp/prettierd.stdout";
  #     StandardErrorPath = "/tmp/prettierd.stderr";
  #   };
  #   command = "prettierd start";
  # };

  environment.launchDaemons."limit.maxfiles.plist".source = ./limit.maxfiles.plist;
}
