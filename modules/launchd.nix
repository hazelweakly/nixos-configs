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

  # figure this out later
  # launchd.daemons."limit.maxfiles".SoftResourceLimits.NumberOfFiles = 1048576;
  # launchd.daemons."limit.maxfiles".HardResourceLimits.NumberOfFiles = 1048576;
}


