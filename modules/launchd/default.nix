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

  launchd.user.agents.blackd = {
    path = [ pkgs.black ];
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      UserName = profiles.user.username;
      GroupName = "staff";
      StandardOutPath = "/tmp/blackd.stdout";
      StandardErrorPath = "/tmp/blackd.stderr";
    };
    command = "blackd";
  };

  # TODO: too much effort to rewrite the whole thing to not daemon fork.
  # launchd.user.agents.prettierd = {
  #   path = [ pkgs.myNodePackages pkgs.nodejs ];
  #   serviceConfig = {
  #     KeepAlive = true;
  #     RunAtLoad = true;
  #     UserName = profiles.user.username;
  #     GroupName = "staff";
  #     StandardOutPath = "/tmp/prettierd.stdout";
  #     StandardErrorPath = "/tmp/prettierd.stderr";
  #   };
  #   command = "prettierd start";
  # };

  environment.launchDaemons."limit.maxfiles.plist".source = ./limit.maxfiles.plist;
}
