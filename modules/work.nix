{ pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [ fnm yarn nodejs ];
  }
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.brews = [ "postgresql@14" "tailscale" "postgis" ];
  })
])
