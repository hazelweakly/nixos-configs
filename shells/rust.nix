{ pkgs ? import <nixpkgs> { }, channel ? "nightly", date ? "2019-12-20", ... }:

# Assumes <nixpkgs> has mozilla overlay setup.
# below is an example nix/default.nix if you're using `niv`:
#
# let moz = import sources.nixpkgs-mozilla;
# in import sources.nixpkgs {
#   overlays = [ moz ];
#   config.allowUnfree = true;
# }
#
# Pick a date using this: https://rust-lang-nursery.github.io/rust-toolstate/
# https://rust-lang.github.io/rustup-components-history/

let rPkg = pkgs.rustChannelOf { inherit date channel; };
in pkgs.mkShell {
  buildInputs = [ rPkg.rust ];
  RUST_BACKTRACE = 1;

  # This is for Nix/NixOS compatibility with RLS/rust-analyzer
  RUST_SRC_PATH = "${rPkg.rust-src}/lib/rustlib/src/rust/src";
}
