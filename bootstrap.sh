#!/usr/bin/env bash

set -euo pipefail

echo "installing xtool stuffs by invoking a missing command (git)"
git --version || :

echo "installing nix"
if ! command -v nix; then
  sh <(curl -L https://nixos.org/nix/install)
fi

echo "installing kitty app"
if ! command -v kitty; then
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi

echo "making personal directory"
mkdir -p ~/src/personal

echo "setting up ssh-keygen with chosen email"
if ! [[ -f ~/.ssh/id_ed25519 ]]; then
  read -r email -p 'email :'
  ssh-keygen -t ed2559 -C "$email" -N '' -f ~/.ssh/id_ed25519
fi

echo 'adding nix config stuff to /etc/nix/nix.conf if needed'
if ! grep 'flakes' /etc/nix/nix.conf; then
  printf '\nexperimental-features = nix-command flakes\n' | sudo tee -a /etc/nix/nix.conf

  sudo mv /etc/shells{,.old}
  sudo mv /etc/zshrc{,old}
  if ! grep 'private/var/run' /etc/synthetic.conf; then
    printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
    /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
  fi
fi

echo "installing homebrew"
if ! command -v brew; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "cloning my dotfiles (this will fail until I've added the ssh key to the profile)"
if [[ ! -d ~/src/personal/nixos-configs ]]; then
  git clone git@github.com:hazelweakly/nixos-configs.git ~/src/personal/nixos-configs
fi

echo "running nix update"
zsh ~/src/personal/nixos-configs/dots/zsh/fn/update

echo "remove potentially stale files and then run it again to make sure things are appropriately generated via nix"
sudo mv /etc/shells{,old}
sudo mv /etc/zshrc{,old}
sudo mv /etc/nix/nix.conf{,old}

echo "setting new zsh as chsh"
if [[ -x /run/current-system/sw/bin/zsh ]]; then
  chsh -s /run/current-system/sw/bin/zsh
fi
