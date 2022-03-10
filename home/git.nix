{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    ignores = [ ".DS_Store" ];
    fetch = {
      prune = true;
    };
    extraConfig = {
      rerere.enabled = true;
      rerere.autoupdate = true;
      color.ui = true;
      diff.colorMoved = "default";
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
