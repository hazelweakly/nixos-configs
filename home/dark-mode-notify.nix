{ pkgs, lib, config, ... }: {
  launchd.agents.dark-mode-notify = {
    enable = true;
    config = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/tmp/dark-mode-notify.stdout";
      StandardErrorPath = "/tmp/dark-mode-notify.stderr";
      ProgramArguments = [ "dark-mode-notify" "switch-theme" ];
      EnvironmentVariables = {
        PATH = lib.makeBinPath [ pkgs.dark-mode-notify pkgs.switch-theme pkgs.neovim-remote ];
      };
    };
  };
}
