{ pkgs, config, ... }: {
  environment.launchDaemons."limit.maxfiles.plist".source = ./limit.maxfiles.plist;
}
