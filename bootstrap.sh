#!/usr/bin/env bash

set -euo pipefail

echo "installing xtool stuffs by invoking a missing command (git)"
git --version || :

if ! command -v nix; then
  echo "installing nix"
  curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
fi

if ! command -v kitty && ! [[ -d /Applications/kitty.app ]]; then
  echo "installing kitty app"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
fi

echo "making personal directory"
mkdir -p ~/src/personal

if ! [[ -f ~/.ssh/id_ed25519 ]]; then
  echo "setting up ssh-keygen with chosen email"
  read -r email
  printf 'email: '
  ssh-keygen -t ed25519 -C "$email" -N '' -f ~/.ssh/id_ed25519
fi

if ! grep 'flakes' /etc/nix/nix.conf; then
  echo 'adding nix config stuff to /etc/nix/nix.conf if needed'
  printf '\nexperimental-features = nix-command flakes\n' | sudo tee -a /etc/nix/nix.conf

  sudo mv /etc/shells{,.old}
  sudo mv /etc/zshrc{,old}
  if ! grep 'private/var/run' /etc/synthetic.conf; then
    printf 'run\tprivate/var/run\n' | sudo tee -a /etc/synthetic.conf
    /System/Library/Filesystems/apfs.fs/Contents/Resources/apfs.util -t
  fi
fi

if [[ ! -x /opt/homebrew/bin/brew ]]; then
  echo "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ ! -d ~/src/personal/nixos-configs ]]; then
  echo "cloning my dotfiles (this will fail until I've added the ssh key to the profile)"
  git clone git@github.com:hazelweakly/nixos-configs.git ~/src/personal/nixos-configs
fi

echo "running nix update"
zsh ~/src/personal/nixos-configs/dots/zsh/fn/update

echo "remove potentially stale files and then run it again to make sure things are appropriately generated via nix"
sudo mv /etc/shells{,old}
sudo mv /etc/zshrc{,old}
sudo mv /etc/nix/nix.conf{,old}

echo "running the nix update again, babe"
zsh ~/src/personal/nixos-configs/dots/zsh/fn/update

if [[ -x /run/current-system/sw/bin/zsh ]]; then
  echo "setting new zsh as chsh"
  chsh -s /run/current-system/sw/bin/zsh
fi
