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
        name = pkgs.qogir-icon-theme.pname;
        package = pkgs.qogir-icon-theme;
      };

      theme = {
        name = pkgs.rose-pine-gtk-theme.meta.description;
        package = pkgs.rose-pine-gtk-theme;
      };

      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };

      # gtk3.extraConfig = {
      #   Settings = ''
      #     gtk-application-prefer-dark-theme=1
      #   '';
      # };

      # gtk4.extraConfig = {
      #   Settings = ''
      #     gtk-application-prefer-dark-theme=1
      #   '';
      # };
    };

    home.sessionVariables.GTK_THEME = config.gtk.theme.name;
    home.packages = extensions;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        "clock-format" = "12h";
        "font-antialiasing" = "none";
        "font-hinting" = "none";
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
      "org/gnome/desktop/wm/preferences" = {
        workspace-names = [ "Main" ];
      };
      "org/gnome/settings-daemon/plugins/color" = {
        "night-light-enabled" = true;
        "night-light-temperature" = 2444;
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = builtins.map (p: p.extensionUuid) extensions;
        "favorite-apps" = [ "firefox.desktop" "kitty.desktop" "org.gnome.Nautilus.desktop" ];
      };
      "org/gnome/shell/extensions/user-theme" = {
        name = config.gtk.theme.name;
      };
      "org/gtk/settings/file-chooser" = { "clock-format" = "12h"; };
    };
  })
]
