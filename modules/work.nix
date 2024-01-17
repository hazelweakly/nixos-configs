{ pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    environment.systemPackages = [ ];
  }
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.brews = [ ];
  })
])
