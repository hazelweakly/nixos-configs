# nixos-configs

Configurations for my NixOS and macOS systems (work/home laptops)

## Install Instructions

- lol

```bash
# on osx
./bootstrap.sh
```

NixOS is "fun". Will maybe document that later if I ever need to reinstall it again.

---

```
/org/gnome/desktop/peripherals/touchpad/tap-to-click
```

```
/org/gnome/desktop/peripherals/mouse/accel-profile
  'adaptive'

/org/gnome/desktop/interface/gtk-key-theme
  'Default'

/org/gnome/desktop/interface/monospace-font-name
  'VictorMono Nerd Font 14'

/org/gnome/desktop/interface/font-antialiasing
  'none'

/org/gnome/desktop/interface/font-hinting
  'none'

/org/gnome/shell/favorite-apps
  ['firefox.desktop', 'kitty.desktop', 'org.gnome.Nautilus.desktop']

/org/gnome/desktop/interface/clock-format
  '12h'

/org/gtk/settings/file-chooser/clock-format
  '12h'

/org/gnome/shell/last-selected-power-profile
  'performance'

/org/gnome/settings-daemon/plugins/color/night-light-enabled
  true

/org/gnome/settings-daemon/plugins/color/night-light-temperature
  uint32 2444

/org/gnome/desktop/peripherals/mouse/natural-scroll
  true

/org/gnome/desktop/peripherals/touchpad/speed
  0.5

/org/gnome/desktop/peripherals/mouse/speed
  0.5
```

```
layout.css.devPixelsPerPx 1.25
```
