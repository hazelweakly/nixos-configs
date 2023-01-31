{ config, pkgs, ... }: {
  programs.git = {
    userName = pkgs.lib.mkForce "hazelweakly";
    userEmail = pkgs.lib.mkForce "hazel@mercury.com";
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
  programs.zsh.initExtra = ''
    eval "$(fnm env --use-on-cd)"
  '';

  # nix.extraOptions = ''
  #   accept-flake-config = true
  #   extra-experimental-features = nix-command flakes repl-flake
  #   extra-substituters = https://cache.mercury.com
  #   extra-trusted-public-keys = cache.mercury.com:yhfFlgvqtv0cAxzflJ0aZW3mbulx4+5EOZm6k3oML+I=
  #   extra-trusted-substituters = https://cache.mercury.com
  #   max-jobs = auto
  # '';

  nix.settings = {
    extra-experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    extra-substituters = "https://cache.mercury.com";
    extra-trusted-public-keys = "cache.mercury.com:yhfFlgvqtv0cAxzflJ0aZW3mbulx4+5EOZm6k3oML+I=";
    extra-trusted-substituters = "https://cache.mercury.com";
    max-jobs = "auto";
    accept-flake-config = true;
  };
}
