{ ... }:
with { pkgs = import ./nix { }; }; {
  nixpkgs = { inherit (pkgs) config overlays; };

  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-nightly-bin.override { pname = "firefox"; };
    profiles.default = {
      isDefault = true;
      id = 0;
      settings = {
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.canvas.azure.accelerated" = true;
        "layout.css.devPixelsPerPx" = "1.25";
        "pdfjs.enableWebGL" = true;
      };
    };
    # TODO: Figure out why tridactyl won't install nicely
  };

  xdg.configFile."tridactyl/tridactylrc".source = ./dots/tridactylrc;
  xdg.configFile."kitty/kitty.conf".source = ./dots/kitty.conf;

  services.lorri.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      core = { pager = "diff-so-fancy | less --tabs=4 -RFX"; };
      color = {
        ui = true;
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
        diff = {
          meta = "11";
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
      };
    };
  };
}
