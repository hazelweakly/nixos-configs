{ config, pkgs, ... }:

with builtins;
with pkgs.lib;
let
  myNvim = import ./neovim.nix { inherit pkgs; };
  kt = t: toString (./dots/kitty + "/tempus_${t}");
  themeSwitch = pkgs.writeShellScriptBin "switch-theme" ''
    DISPLAY=:0 DESKTOP_SESSION=gnome TERM=xterm-256color HOME="${config.users.users.hazel.home}" t="$1"

    case "$t" in
      dark)  gt="darker" nvim_colors="tempus_dusk" kitty_theme=${kt "dusk"} ;;
      light) gt="Polar" nvim_colors="tempus_dawn" kitty_theme=${kt "dawn"}
        readarray -t devices < <(colormgr get-devices | grep ID | cut -d' ' -f7-)
        for i in False True; do for x in "''${devices[@]}"; do colormgr device-set-enabled "$x" "$i"; done; done
        ;;
    esac

    ts=(desktop.{"interface gtk-theme","wm.preferences theme"} "shell.extensions.user-theme name")
    for x in "''${ts[@]}"; do gsettings set org.gnome.$x "Nordic-''${gt}-standard-buttons"; done
    echo "$t" > $HOME/.local/share/theme; echo "colorscheme $nvim_colors" > $HOME/.config/nvim_colors
    ln -sf $HOME/.task/{$t,current}.theme
    ln -sf $kitty_theme $HOME/.config/kitty_current_theme
    find /tmp/kitty* -maxdepth 1 -exec kitty @ --to=unix:{} set-colors -a -c $kitty_theme \;
  '';

  system-dconf = pkgs.writeTextDir "/dconf/site-dconf" ''
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
    num-workspaces=1
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
    enabled-extensions=['pomodoro@arun.codito.in', 'user-theme@gnome-shell-extensions.gcampax.github.com', 'gsconnect@andyholmes.github.io', 'dash-to-dock@micxgx.gmail.com', 'nightthemeswitcher@romainvigier.fr', 'workrave@workrave.org']
    favorite-apps=['firefox.desktop', 'kitty.desktop', 'org.gnome.Nautilus.desktop']

    [org/gnome/shell/weather]
    automatic-location=true

    [org/gnome/system/location]
    enabled=true

    [org/gnome/shell/extensions/dash-to-dock]
    apply-custom-theme=false
    hot-keys=true
    middle-click-action='launch'
    shift-click-action='minimize'
    shift-middle-click-action='launch'

    [org/gnome/shell/extensions/gsconnect]
    devices=['5bc3881e4d02cf17']
    id='47869f92-b241-4a00-9201-11f692751108'
    name='hazelweaklyeakly'

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
    command-sunrise='${themeSwitch}/bin/theme-switch "light"'
    command-sunset='${themeSwitch}/bin/theme-switch "dark"'
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

    [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
    binding='<Primary>F12'
    command='tdrop -ma kitty'
    name='toggle term'

    [org/gnome/settings-daemon/plugins/power]
    sleep-inactive-ac-timeout=0
    sleep-inactive-ac-type='nothing'
    sleep-inactive-battery-timeout=0
    sleep-inactive-battery-type='nothing'
  '';

  customDconfDb = pkgs.runCommand "compile-dbus" { }
    "${pkgs.dconf}/bin/dconf compile $out ${system-dconf}/dconf";

  profile = ''
    user-db:user
    system-db:site
  '';

  system-dconf-db = pkgs.stdenv.mkDerivation {
    name = "complete-system-dconf";
    buildCommand = ''
      mkdir -p $out/etc/dconf/profile
      mkdir -p $out/etc/dconf/db
      echo "${profile}" > $out/etc/dconf/profile/user
      ln -sf ${customDconfDb} $out/etc/dconf/db/site
    '';
  };

in {
  programs.dconf.packages = [ system-dconf-db ];

  environment.systemPackages = with pkgs; [
    gnome3.dconf
    gnome3.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.gsconnect
    gnomeExtensions.night-theme-switcher
    # gnomeExtensions.paperwm
    nordic
    nordic-polar
    paper-icon-theme
    plata-theme
    tdrop
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
  systemd.user.services.profile-update = {
    environment.DISPLAY = ":0";
    serviceConfig.Type = "oneshot";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ myNvim zsh sudo cacert curl ];
    script = ''
      source ${config.system.build.setEnvironment}
      zsh -ilc zup || true
      zsh -ilc nvim --headless '+PlugUpgrade' '+PlugDiff' '+PlugUpdate' '+PlugClean!' '+qall' || true
    '';
  };
}
