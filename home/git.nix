{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    extraConfig = {
      rerere.enabled = true;
      rerere.autoupdate = true;
      core.pager = "${pkgs.gitAndTools.delta}/bin/delta";
      interactive.diffFilter =
        "${pkgs.gitAndTools.delta}/bin/delta --color-only";
      color.ui = true;
      diff.colorMoved = "default";
      delta = {
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
