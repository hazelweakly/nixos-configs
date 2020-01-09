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
        "browser.ctrlTab.recentlyUsedOrder" = false;
        "browser.newtab.extensionControlled" = true;
        "browser.newtab.privateAllowed" = true;
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
  xdg.configFile."kitty".source = ./dots/kitty;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";

  services.lorri.enable = true;
  programs.direnv.enable = true;
  # programs.zsh = {
  #   enable = true;
  #   dotDir = ".config/zsh";
  #   # Already configured with zplugin
  #   enableCompletions = false;
  #   initExtraBeforeCompInit =
  # };

  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      core = { pager = "${pkgs.gitAndTools.delta}/bin/delta --commit-style=box --highlight-removed --light"; };
      color.ui = true;
    };
  };
}
