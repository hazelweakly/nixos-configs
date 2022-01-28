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

