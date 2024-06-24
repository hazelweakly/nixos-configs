{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    userName = lib.mkDefault "Hazel Weakly";
    userEmail = lib.mkDefault "hazel@theweaklys.com";
    package = pkgs.gitFull;
    lfs.enable = true;
    ignores = [ ".DS_Store" ];
    extraConfig = {
      fetch.prune = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      color.ui = true;
      diff.colorMoved = "default";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.twohead = "ort";
      remote.origin = {
        tagopt = "--tags";
        prune = true;
        pruneTags = true;
      };
      # TODO: https://stackoverflow.com/questions/16678072/fetching-all-tags-from-a-remote-with-git-pull
    };
    aliases = {
      ref = "!git rev-parse --short HEAD | tr -d '\n'";
      cp-ref = "!git rev-parse --short HEAD | tr -d '\n' | pbcopy";
    };
    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = true;
        features = "side-by-side line-numbers decorations";
        commit-decoration-style = "box";
        file-decoration-style = "box";
        hunk-header-decoration-style = "box";
      };
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
