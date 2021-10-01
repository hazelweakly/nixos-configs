{ config, pkgs, ... }:
let dir = config.home.homeDirectory + "/src/personal/nixos-configs";
in
with builtins;
with pkgs.lib; {
  xdg.configFile."coc/extensions/coc-lua-data/sumneko-lua-ls/bin/Linux/lua-language-server".source =
    pkgs.sumneko-lua-language-server + "/bin/lua-language-server";
  xdg.configFile."coc/extensions/coc-python-data/languageServer".source =
    pkgs.python-language-server + "/lib";

  services.lorri.enable = true;

  xdg.configFile."mpv/mpv.conf".text = ''
    hwdec=auto-safe
    vo=gpu
    profile=gpu-hq
  '';

  xdg.configFile."run-or-raise".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/run-or-raise";

  services.syncthing.enable = true;
  systemd.user.services.neuron = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart =
      "${pkgs.neuron-notes}/bin/neuron -d ${config.home.homeDirectory}/zettelkasten rib -ws 127.53.54.1:50000 --pretty-urls";
  };
  systemd.user.services.neuron-notes = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart =
      "${pkgs.neuron-notes}/bin/neuron -d ${config.home.homeDirectory}/Documents/notes gen -ws 127.53.54.2:50001 --pretty-urls";
  };
  systemd.user.services.easyeffects = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";
    Service.ExecStopPost = "${pkgs.easyeffects}/bin/easyeffects -q";
  };
}

