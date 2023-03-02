{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    environment.launchDaemons."limit.maxfiles.plist".source = ./limit.maxfiles.plist;
  })
]
