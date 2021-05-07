#!/usr/bin/env bash

nix --experimental-features 'nix-command flakes' build -L \
  '.#nixosConfigurations.'"$(hostname)"'.config.system.build.toplevel'

sudo nix build --profile /nix/var/nix/profiles/system "$(readlink -f result)"

sudo nix shell -vv "$(readlink -f result)" -c switch-to-configuration switch
