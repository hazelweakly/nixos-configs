{ config, ... }:
with { pkgs = import ./nix { }; };
with builtins;
with pkgs.lib; {
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

  home.file.".local/share/fonts/VictorMono".source = ./dots/VictorMono;

  xdg.configFile."tridactyl/tridactylrc".source = ./dots/tridactylrc;
  xdg.configFile."kitty".source = ./dots/kitty;
  xdg.configFile."nvim".source = ./dots/nvim;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  xdg.enable = true;

  services.lorri.enable = true;
  programs.direnv.enable = true;

  xdg.configFile."zsh/completions/src.completion".text =
    "compctl -/ -W ~/src src";
  programs.zsh = let
    zshrc = concatMapStringsSep "\n" (n: readFile (./dots/zsh + "/${n}"))
      (filter (hasSuffix ".zsh") (attrNames (readDir ./dots/zsh)));
  in {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraBeforeCompInit = ''
      if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      typeset -A ZPLGM=(
        BIN_DIR         ${config.xdg.dataHome}/zsh/zplugin/bin
        HOME_DIR        ${config.xdg.dataHome}/zsh/zplugin
        COMPINIT_OPTS   -C
      )
      if ! [[ -d ${config.xdg.dataHome}/zsh/zplugin/bin ]]; then
        mkdir -p ${config.xdg.dataHome}/zsh/zplugin
        git clone --depth=1 https://github.com/zdharma/zplugin.git ${config.xdg.dataHome}/zsh/zplugin/bin
      fi
      source ${config.xdg.dataHome}/zsh/zplugin/bin/zplugin.zsh
    '';
    initExtra = zshrc;
  };

  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      core = {
        pager =
          "${pkgs.gitAndTools.delta}/bin/delta --commit-style=box --highlight-removed --light";
      };
      color.ui = true;
    };
  };
}
