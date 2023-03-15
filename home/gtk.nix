{ config, pkgs, lib, systemProfile, ... }:
let
  extensions = with pkgs; with gnomeExtensions; [
    user-themes
    night-theme-switcher
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
      # /org/gnome/shell/extensions/nightthemeswitcher/gtk-variants/day
      #   'rose-pine-dawn'
      #
      # /org/gnome/desktop/interface/gtk-theme
      #   'rose-pine-dawn'
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/gtk-variants/night
      #   'rose-pine-moon'
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/enabled
      #   true
      #
      # /org/gnome/shell/extensions/user-theme/name
      #   ''
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/day
      #   ''
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/day
      #   'rose-pine-moon'
      #
      # /org/gnome/shell/extensions/user-theme/name
      #   'rose-pine-moon'
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/night
      #   'rose-pine-moon'
      # /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/day
      #   'Numix-Cursor'
      #
      # /org/gnome/desktop/interface/cursor-theme
      #   'Numix-Cursor'
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/day
      #   'Numix-Cursor-Light'
      #
      # /org/gnome/desktop/interface/cursor-theme
      #   'Numix-Cursor-Light'
      #
      # /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/night
      #   'Numix-Cursor'
      #
      #



      "org/gnome/system/location" = { "enabled" = true; };
      "org/gnome/desktop/interface" = {
        "clock-format" = "12h";
        "font-antialiasing" = "grayscale";
        "font-hinting" = "none";
        "monospace-font-name" = "VictorMono Nerd Font 14";
        "text-scaling-factor" = 1.25;
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

# /org/gnome/desktop/interface/color-scheme
#   'prefer-dark'
#
# /org/gnome/desktop/interface/color-scheme
#   'default'
#
# /org/gnome/desktop/interface/color-scheme
#   'prefer-dark'
#
# /org/gnome/desktop/interface/color-scheme
#   'default'
#
# /org/gnome/control-center/last-panel
#   'wifi'
#
# /org/gnome/control-center/last-panel
#   'background'
#
# /org/gnome/shell/extensions/nightthemeswitcher/gtk-variants/enabled
#   true
#
# /org/gnome/desktop/interface/gtk-theme
#   'Adwaita'
#
# /org/gnome/shell/extensions/nightthemeswitcher/gtk-variants/day
#   'Adwaita'
#
# /org/gnome/shell/extensions/nightthemeswitcher/gtk-variants/day
#   'rose-pine-dawn'
#
# /org/gnome/desktop/interface/gtk-theme
#   'rose-pine-dawn'
#
# /org/gnome/shell/extensions/nightthemeswitcher/gtk-variants/night
#   'rose-pine-moon'
#
# /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/enabled
#   true
#
# /org/gnome/shell/extensions/user-theme/name
#   ''
#
# /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/day
#   ''
#
# /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/day
#   'rose-pine-moon'
#
# /org/gnome/shell/extensions/user-theme/name
#   'rose-pine-moon'
#
# /org/gnome/shell/extensions/nightthemeswitcher/shell-variants/night
#   'rose-pine-moon'
#
# /org/gnome/shell/extensions/nightthemeswitcher/icon-variants/enabled
#   true
#
# /org/gnome/desktop/interface/icon-theme
#   'Adwaita'
#
# /org/gnome/shell/extensions/nightthemeswitcher/icon-variants/day
#   'Adwaita'
#
# /org/gnome/shell/extensions/nightthemeswitcher/icon-variants/day
#   'Qogir'
#
# /org/gnome/desktop/interface/icon-theme
#   'Qogir'
#
# /org/gnome/shell/extensions/nightthemeswitcher/icon-variants/night
#   'Qogir-dark'
#
# /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/enabled
#   true
#
# /org/gnome/desktop/interface/cursor-theme
#   'Adwaita'
#
# /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/day
#   'Adwaita'
#
# /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/day
#   'Qogir'
#
# /org/gnome/desktop/interface/cursor-theme
#   'Qogir'
#
# /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/day
#   'Numix-Cursor'
#
# /org/gnome/desktop/interface/cursor-theme
#   'Numix-Cursor'
#
# /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/day
#   'Numix-Cursor-Light'
#
# /org/gnome/desktop/interface/cursor-theme
#   'Numix-Cursor-Light'
#
# /org/gnome/shell/extensions/nightthemeswitcher/cursor-variants/night
#   'Numix-Cursor'
#
