{ config, pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork {
  programs.git = {
    userName = pkgs.lib.mkForce "Hazel Weakly";
    userEmail = pkgs.lib.mkForce "hazel@work.com";
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
          name = "Hazel Weakly";
          email = "hazel@theweaklys.com";
        };
      };
    }];
  };
}
