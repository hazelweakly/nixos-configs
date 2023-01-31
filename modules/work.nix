{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ fnm yarn nodejs ];
  nix.settings.trusted-users = [ "hazelweakly" ];

  homebrew.brews = [ "postgresql@14" "tailscale" "postgis" ];
}
