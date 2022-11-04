{ pkgs, lib, config, ... }: {
  launchd.agents.dark-mode-notify = {
    enable = true;
    config = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/dark-mode-notify.stdout";
      StandardErrorPath = "/tmp/dark-mode-notify.stderr";
      ProgramArguments = [ "${pkgs.dark-mode-notify}/bin/dark-mode-notify" "${pkgs.switch-theme}/bin/switch-theme" ];
      EnvironmentVariables = {
        PATH =
          (lib.makeBinPath [ pkgs.dark-mode-notify pkgs.switch-theme pkgs.neovim-remote ])
          + ":/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
        ;
      };
    };
  };
}
