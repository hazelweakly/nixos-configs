{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
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
}
