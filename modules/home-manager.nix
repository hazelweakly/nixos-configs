{ pkgs, self, userProfile, systemProfile, inputs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm";
  home-manager.extraSpecialArgs = { inherit self inputs userProfile systemProfile; };
}
