{ pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [ ];
  }
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.brews = [ ];
  })
])
