{ config, pkgs, lib, profiles, ... }: lib.mkIf profiles.work {
  home-manager.users.${profiles.user.username} = { config, ... }: {
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
  };

  # mas seems unmaintained. cry
  # homebrew.masApps = {
  #   Tailscale = 1475387142;
  # };

  environment.systemPackages = with pkgs; [ pulumi-bin gum packer gh jq dasel figlet /* ansible */ google-cloud-sdk ];

  homebrew.taps = [ "equinix-labs/otel-cli" "withgraphite/tap" ];
  homebrew.casks = [ "zoom" ];
  homebrew.brews = [ "tailscale" "lxc" "otel-cli" "withgraphite/tap/graphite" ];
}
