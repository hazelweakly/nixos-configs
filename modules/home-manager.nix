{ pkgs, profiles, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm";
  home-manager.users = let users = import ../home/users; in { ${profiles.user.username} = users.hazelweakly; inherit (users) root; };
  home-manager.extraSpecialArgs = { inherit profiles; };
}
