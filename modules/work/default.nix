{ pkgs, lib, profiles, ... }: lib.mkIf profiles.work {
  home-manager.users.hazelweakly = { config, ... }: {
    programs.git = {
      userName = pkgs.lib.mkForce "Hazel Weakly";
      userEmail = pkgs.lib.mkForce "hazel@seaplane.io";
      includes = [{
        condition = "gitdir:~/src/personal/";
        contents = {
          commit.gpgSign = false;
          user = {
            name = "hazelweakly";
            email = "hazel@theweaklys.com";
          };
        };
      }];
    };
  };
}
