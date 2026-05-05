{ pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    environment.systemPackages = [ ];
    ids.gids.nixbld = 350;
  }
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.brews = [ ];
  })
])
