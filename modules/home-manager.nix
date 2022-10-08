{ pkgs, profiles, self, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "hm";
  home-manager.users = let users = import ../home/users { inherit self; }; in { ${profiles.user.username} = users.hazelweakly; inherit (users) root; };
  home-manager.extraSpecialArgs = { inherit profiles self; };
  users.users.${profiles.user.username}.home = "/Users/{profiles.user.username}";
}
