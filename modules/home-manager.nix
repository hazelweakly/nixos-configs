{ pkgs, self, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm";
  home-manager.extraSpecialArgs = { inherit self; };
}
