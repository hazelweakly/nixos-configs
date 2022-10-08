{ pkgs, config, profiles, ... }: {
  launchd.user.agents.dark-mode-notify = {
    path = [ pkgs.dark-mode-notify pkgs.switch-theme pkgs.neovim-remote config.environment.systemPath ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = profiles.user.username;
      GroupName = "staff";
      StandardOutPath = "/tmp/dark-mode-notify.stdout";
      StandardErrorPath = "/tmp/dark-mode-notify.stderr";
    };
    command = "dark-mode-notify switch-theme";
  };

  environment.launchDaemons."limit.maxfiles.plist".source = ./limit.maxfiles.plist;
}
