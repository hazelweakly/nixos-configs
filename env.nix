{ config, pkgs, ... }:

# if dconf doesn't take effect,
# dconf reset /org/gnome/shell/enabled-extensions
# may need to be run
#
# also, check out: https://github.com/nix-community/home-manager/blob/master/modules/misc/dconf.nix#L52
# which has different tradeoffs and might not have this issue

with builtins;
with pkgs.lib;
let
  myNvim = pkgs.callPackage ./neovim.nix { };
  kt = t: toString (./dots/kitty + "/${t}");
  themeSwitch = pkgs.writeShellScriptBin "switch-theme" ''
    DISPLAY=:0 DESKTOP_SESSION=gnome TERM=xterm-256color HOME="${config.users.users.hazel.home}" t="$1"

    case "$t" in
      dark)  gt="darker" kitty_theme=${kt "tokyonight_night"} ;;
      light) gt="Polar" kitty_theme=${kt "tokyonight_day"}
        readarray -t devices < <(colormgr get-devices | grep ID | cut -d' ' -f7-)
        for i in False True; do for x in "''${devices[@]}"; do colormgr device-set-enabled "$x" "$i"; done; done
        ;;
    esac

    ts=(desktop.{"interface gtk-theme","wm.preferences theme"} "shell.extensions.user-theme name")
    for x in "''${ts[@]}"; do gsettings set org.gnome.$x "Nordic-''${gt}-standard-buttons"; done
    echo "$t" > $HOME/.local/share/theme
    ln -sf $HOME/.task/{$t,current}.theme
    ln -sf $kitty_theme $HOME/.config/kitty_current_theme
    find /tmp/kitty* -maxdepth 1 -exec kitty @ --to=unix:{} set-colors -a -c $kitty_theme \;
  '';

  system-dconf = pkgs.writeTextFile {
    name = "system-dconf";
    destination = "/dconf/gdm-system-dconf";
    text = ''
      [org/gnome/desktop/interface]
      clock-format='12h'
      cursor-theme='Paper'
      document-font-name='Noto Sans 11'
      enable-hot-corners=false
      font-name='Noto Sans 9'
      gtk-im-module='gtk-im-context-simple'
      gtk-theme='Nordic-Polar-standard-buttons'
      icon-theme='Zafiro-icons'
      monospace-font-name='VictorMono Nerd Font 9'

      [org/gnome/desktop/wm/preferences]
      num-workspaces=4
      titlebar-font='Noto Sans Bold 11'

      [org/gnome/mutter]
      experimental-features=['scale-monitor-framebuffer']

      [org/gnome/mutter/keybindings]
      switch-monitor=['XF86Display']

      [org/gnome/desktop/sound]
      event-sounds=false

      [org/gnome/desktop/peripherals/touchpad]
      tap-to-click=true

      [org/gnome/shell]
      enabled-extensions=['user-theme@gnome-shell-extensions.gcampax.github.com', 'nightthemeswitcher@romainvigier.fr', 'pop-shell@system76.com']
      favorite-apps=['firefox.desktop', 'kitty.desktop', 'org.gnome.Nautilus.desktop']

      [org/gnome/shell/weather]
      automatic-location=true

      [org/gnome/system/location]
      enabled=true

      [org/gnome/settings-daemon/plugins/color]
      night-light-enabled=true
      night-light-last-coordinates=(45.512230, -122.658722)
      night-light-schedule-automatic=true
      night-light-schedule-from=18.0
      night-light-schedule-to=7.0
      night-light-temperature=uint32 2000

      [org/gnome/shell/overrides]
      workspaces-only-on-primary=false
      edge-tiling=true
      attach-modal-dialogs=false

      [org/gnome/shell/extensions/user-theme]
      name='Nordic-Polar-standard-buttons'

      [org/gnome/shell/extensions/nightthemeswitcher]
      commands-enabled=true
      cursor-variant-original='Paper'
      gtk-variants-enabled=false
      icon-variants-enabled=false
      manual-gtk-variants=false
      manual-shell-variants=false
      manual-time-source=false
      ondemand-time='day'
      shell-variants-enabled=false
      time-source='nightlight'

      [org/gnome/shell/extensions/nightthemeswitcher/commands]
      enabled=true
      sunrise='${themeSwitch}/bin/switch-theme "light"'
      sunset='${themeSwitch}/bin/switch-theme "dark"'

      [org/gnome/settings-daemon/plugins/power]
      sleep-inactive-ac-timeout=0
      sleep-inactive-ac-type='nothing'
      sleep-inactive-battery-timeout=0
      sleep-inactive-battery-type='nothing'

      [org/gnome/shell/extensions/pop-shell]
      active-hint=true
      gap-inner=uint32 3
      gap-outer=uint32 3
      show-title=false
      smart-gaps=true
      snap-to-grid=true
      tile-by-default=true
    '';
  };

  customDconfDb = pkgs.stdenv.mkDerivation {
    name = "gdm-dconf-db-sys";
    buildCommand = "${pkgs.dconf}/bin/dconf compile $out ${system-dconf}/dconf";
  };

  system-dconf-db = pkgs.stdenv.mkDerivation {
    name = "system-dconf-profile";
    buildCommand = ''
      # Check that the GDM profile starts with what we expect.
      if [ $(head -n 1 ${pkgs.gnome.gdm}/share/dconf/profile/gdm) != "user-db:user" ]; then
        echo "GDM dconf profile changed, please update gdm.nix"
        exit 1
      fi
      # Insert our custom DB behind it.
      sed '2ifile-db:${customDconfDb}' ${pkgs.gnome.gdm}/share/dconf/profile/gdm > $out
    '';
  };

in
{
  programs.dconf.profiles.settings = system-dconf-db;

  services.xserver.desktopManager.gnome.sessionPath = [ pkgs.gnome40Extensions."pop-shell@system76.com" ];
  environment.systemPackages = with pkgs; [
    gnome3.gnome-tweaks
    gnome40Extensions."just-perfection-desktop@just-perfection"
    gnome40Extensions."gsconnect@andyholmes.github.io"
    gnome40Extensions."nightthemeswitcher@romainvigier.fr"
    gnome40Extensions."taskwhisperer-extension@infinicode.de"
    gnome40Extensions."pop-shell@system76.com"
    gnome40Extensions."run-or-raise@edvard.cz"
    nordic
    themeSwitch
    zafiro-icons
  ];

  programs.dconf.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  systemd.services.dconf-update = {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.gnome3.dconf ];
    script = "dconf update";
  };
}
