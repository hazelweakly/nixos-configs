{ pkgs, lib, inputs, self, ... }: {
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
