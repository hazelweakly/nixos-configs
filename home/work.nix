{ config, pkgs, ... }: {
  programs.git = {
    userName = pkgs.lib.mkForce "hazelweakly";
    userEmail = pkgs.lib.mkForce "hazel@seaplane.io";
    extraConfig = {
      commit.gpgSign = true;
      tag.gpgSign = true;
      user.signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      gpg.format = "ssh";
    };
    includes = [{
      condition = "gitdir:~/src/personal/";
      contents = {
        commit.gpgSign = false;
        tag.gpgSign = false;
        user = {
          name = "hazelweakly";
          email = "hazel@theweaklys.com";
        };
      };
    }];
  };
}
