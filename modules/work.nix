{ pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    ids.gids.nixbld = 350;
  }
])
