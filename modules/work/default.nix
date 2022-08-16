{ pkgs, ... }: {
  # imports = [ ./gpg.nix ];
  home-manager.users.hazelweakly = { config, ... }: {
    # imports = [ ../../home/gpg.nix ];
    programs.git = {
      # userName = pkgs.lib.mkForce "Hazel Weakly";
      # signing.signByDefault = false;
      # signing.key = null;
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
