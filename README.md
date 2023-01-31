# nixos-configs

Configurations for my NixOS and macOS systems (work/home laptops)

## Design philosophy

- Avoid channels wherever possible
- System overlays should be available in all nix CLI tools
- Full system can be created from a single command with no incremental bootstrapping needed
- Whenever possible, have declarative configuration of environment.
  - Try to keep configuration in the natural language of that environment. (eg don't fully embed vimrc into nix)
- System configuration should be buildable from CI

## TODO

- Reduce closure sizes of things
- Particularly neovim...

## Install Instructions

- lol

1. xcode-select --install
2. sh <(curl -L https://nixos.org/nix/install)
3. curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
4. ssh-keygen
5. clone this repo
6. Manually add the nixConfig stuff to /etc/nix/nix.conf and restart daemon. sigh. (to enable flakes).
   - `printf '\nexperimental-features = nix-command flakes\n' | sudo tee -a /etc/nix/nix.conf`
   - `sudo mv /etc/shells{,.old}` `sudo mv /etc/zshrc{,.old}`
7. `printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf`, `/System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t`
8. `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
9. zsh dots/zsh/fn/update
10. once it works, remove: /etc/shells, /etc/zshrc, /etc/nix/nix.conf and run again
11. Execute `chsh -s $(which zsh)` to use nix's zsh on starting up kitty.

If you rename your home folder and nix hates you, check the `XDG_` environment variables and everything else in env.

Might be needed?: `sudo ln -s /nix/var/nix/profiles/system /run/current-system`

Might also be needed?

- wait for home manager to fail
- dig through the /run/current-system/activate script to find the home-manager activation script
- execute it normally ??? y tho???

---

- https://github.com/echasnovski/nvim/tree/master/after/ftplugin
- https://github.com/miversen33/import.nvim
- https://www.lua.org/manual/5.1/manual.html#5.4.1 - patterns
- https://github.com/roginfarrer/dotfiles/blob/main/nvim/.config/nvim/lua/user/packerInit.lua
  - requires plugins from user.plugins
- https://old.reddit.com/r/neovim/comments/rw4imi/what_is_the_most_interesting_part_of_your_lua/hrfrcrn/
  - auto require local config for plugins
- https://github.com/olimorris/dotfiles/blob/main/.config/nvim/init.lua
  - shows how to setup full reload of config
  - https://old.reddit.com/r/neovim/comments/puuskh/how_to_reload_my_lua_config_while_using_neovim/
- https://github.com/ray-x/nvim/tree/master/lua/core
  - Should just look through this.

---

Manual stuff:

- https://www.auburnsounds.com/products/Renegate.html
- https://analogobsession.com/wp-content/uploads/2021/11/SweetVox_4.0.pkg
- https://www.meldaproduction.com/downloads
- https://www.xp-pen.com/download-525.html

/org/gnome/desktop/peripherals/touchpad/tap-to-click

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

```
