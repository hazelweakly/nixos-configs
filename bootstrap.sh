#!/usr/bin/env sh

# This script is overly naive and is only here as a place-holder for a real
# solution.

ln -s $PWD/nixos /etc

mkdir -p $HOME/.config/nixpkgs
# ln -s $PWD/home.nix $HOME/.config/nixpkgs/home.nix
