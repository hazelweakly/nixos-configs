{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    # Forcing a rebuild here because the package got corrupted somehow.
    # I'll wait for a few updates and then remove this.
    package = pkgs.gitFull.overrideAttrs (_: { rebuildMe = true; });
    lfs.enable = true;
    ignores = [ ".DS_Store" ];
    settings = {
      user.name = lib.mkDefault "Hazel Weakly";
      user.email = lib.mkDefault "hazel@theweaklys.com";
      fetch.prune = true;
      fetch.pruneTags = true;
      fetch.all = true;
      rerere.enabled = true;
      rerere.autoupdate = true;
      color.ui = true;
      diff.colorMoved = "default";
      diff.algorithm = "histogram";
      push.autoSetupRemote = true;
      # Every push, also push all tags locally that aren't on the server
      # push.followTags = true;
      init.defaultBranch = "main";
      rebase.autoSquash = true;
      rebase.autoStash = true;
      rebase.updateRefs = true;
      pull.twohead = "ort";
      pull.rebase = true;
      branch.sort = "-committerdate";
      merge.conflictstyle = "zdiff3";
      tag.sort = "version:refname";
      remote.origin = {
        tagopt = "--tags";
        prune = true;
        pruneTags = true;
      };
      # TODO: https://stackoverflow.com/questions/16678072/fetching-all-tags-from-a-remote-with-git-pull
      aliases = {
        ref = "!git rev-parse --short HEAD | tr -d '\n'";
        cp-ref = "!git rev-parse --short HEAD | tr -d '\n' | pbcopy";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
      navigate = true;
      features = "side-by-side line-numbers decorations";
      commit-decoration-style = "box";
      file-decoration-style = "box";
      hunk-header-decoration-style = "box";
      hyperlinks = true;
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
