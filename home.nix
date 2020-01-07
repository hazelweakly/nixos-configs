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

  programs.fzf = {
    enable = true;
    changeDirWidgetCommand = "fd -t d -L -c always .";
    changeDirWidgetOptions = [
      "--preview 'lsd --group-dirs first --icon always -t --tree {} | head -200'"
    ];
    defaultCommand = "fd -t f -I -L -c always 2> /dev/null";
    defaultOptions = [ "--color=light --ansi --layout=reverse" ];
    fileWidgetCommand = "fd -L -c always .";
    fileWidgetOptions = let
      preview =
        "(bat --style numbers,changes --color always --paging never --theme GitHub {} || tree -C {}) 2> /dev/null";
    in [ "--preview '${preview} | head -200'" ];
    historyWidgetOptions = [
      ''
        --preview 'echo {} | cut -d\" \" -f2- | fold -w $(($(tput cols)-4))' --preview-window down:4:hidden --bind '?:toggle-preview' ''
    ];
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
