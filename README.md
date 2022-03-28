# nixos-configs

Configurations for my NixOS and macOS systems (work/home laptops)

## Design philosophy

- Avoid channels wherever possible
- System overlays should be available in all nix CLI tools
- Full system can be created from a single command with no incremental bootstrapping needed
- Whenever possible, have declarative configuration of environment.
  - Try to keep configuration in the natural language of that environment. (eg don't fully embed vimrc into nix)
- System configuration should be buildable from CI

## Install Instructions

- lol

1. xcode-select --install
2. sh <(curl -L https://nixos.org/nix/install)
3. curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
4. ssh-keygen
5. clone this repo
6. Manually add the nixConfig stuff to /etc/nix/nix.conf and restart daemon. sigh.
7. zsh dots/zsh/fn/update
8. once it works, remove: /etc/shells, /etc/zshrc, /etc/nix/nix.conf and run again

---

- https://www.lua.org/manual/5.1/manual.html#5.4.1 - patterns
- https://github.com/roginfarrer/dotfiles/blob/main/nvim/.config/nvim/lua/user/packerInit.lua
  - requires plugins from user.plugins
- https://github.com/aitvann/dotfiles/blob/master/nvim/.config/nvim/lua/lsp/utils.lua
  - resolve_capabilities intelligently
- https://old.reddit.com/r/neovim/comments/rw4imi/what_is_the_most_interesting_part_of_your_lua/hrfrcrn/
  - auto require local config for plugins
- https://github.com/olimorris/dotfiles/blob/main/.config/nvim/init.lua
  - shows how to setup full reload of config
  - https://old.reddit.com/r/neovim/comments/puuskh/how_to_reload_my_lua_config_while_using_neovim/
