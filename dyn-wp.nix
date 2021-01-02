{ config, pkgs, ... }:
let sources = import ./nix/sources.nix;
in let
  dynamic-wallpaper = pkgs.stdenv.mkDerivation {
    name = "dynamic-wallpaper";
    nativeBuildInputs = [ pkgs.ncurses pkgs.wrapGAppsHook pkgs.glib ];
    buildInputs = with pkgs; [
      glib
      gawk
      feh
      cron
      xorg.xrandr
      gsettings-desktop-schemas
      dbus
      gnome3.dconf
      coreutils
      ncurses
    ];
    src = sources.dynamic-wallpaper;
    installPhase = ''
      mkdir -p $out/bin $out/share/dynamic-wallpaper
      cp -r ./dwall.sh ./images $out/share/dynamic-wallpaper
      sed -i -e "s!/usr/share/!/share/!g" -e "s!DIR=\"!DIR=\"$out!g" \
          $out/share/dynamic-wallpaper/dwall.sh
      ln -s $out/share/dynamic-wallpaper/dwall.sh $out/bin/dwall
    '';
  };
in {
  home-manager.users.hazel.systemd.user.services.dynamic-wallpaper = {
    Service.Type = "oneshot";
    Service.Environment = [
      "DISPLAY=:0"
      "PATH=${
        pkgs.lib.makeBinPath
        (dynamic-wallpaper.buildInputs ++ pkgs.ncurses.all ++ pkgs.glib.all)
      }"
      "DESKTOP_SESSION=gnome"
      "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
      "XDG_RUNTIME_DIR=/run/user/1000"
      "TERM=xterm-256color"
    ];
    Service.ExecStart = "${dynamic-wallpaper}/bin/dwall -s firewatch";
    Install.WantedBy = [ "graphical-session.target" ];
  };
  home-manager.users.hazel.systemd.user.timers.dynamic-wallpaper = {
    Timer.OnCalendar = "*:0/5";
    Timer.Persistent = "true";
    Timer.Unit = "dynamic-wallpaper.service";
    Install.WantedBy = [ "dynamic-wallpaper.service" ];
  };
}
