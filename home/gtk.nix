{ config, pkgs, lib, systemProfile, ... }:
let
  extensions = with pkgs; with gnomeExtensions; [
    user-themes
    night-theme-switcher
    arc-menu
    just-perfection
    rounded-window-corners
    blur-my-shell
  ];
in
lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    gtk = {
      enable = true;

      iconTheme = {
        name = "Qogir";
        package = pkgs.qogir-icon-theme;
      };

      theme = {
        name = "rose-pine-dawn";
        package = pkgs.rose-pine-gtk-theme;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };
    };

    home.sessionVariables.GTK_THEME = config.gtk.theme.name;
    home.packages = extensions;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        "clock-format" = "12h";
        "font-antialiasing" = "rgba";
        "font-hinting" = "full";
        "monospace-font-name" = "VictorMono Nerd Font 14";
      };
      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "adaptive";
        "natural-scroll" = true;
        "speed" = 0.5;
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        "speed" = 0.5;
        tap-to-click = true;
      };
      "org/gnome/desktop/wm/preferences" = { workspace-names = [ "Main" ]; };
      "org/gnome/settings-daemon/plugins/color" = {
        "night-light-enabled" = true;
        "night-light-temperature" = 2444;
      };
      "org/gnome/desktop/sound" = { "event-sounds" = false; };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = builtins.map (p: p.extensionUuid) extensions;
        "favorite-apps" = [ "firefox.desktop" "kitty.desktop" ];
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = "rose-pine-moon";
      };
      "org/gtk/settings/file-chooser" = { "clock-format" = "12h"; };
    };
  })
]
