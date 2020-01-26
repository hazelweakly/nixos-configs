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

  programs.tmux = {
    enable = true;
    shortcut = "Space";
    escapeTime = 0;
    historyLimit = 100000;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      fpp
      copycat
      {
        plugin = yank;
        extraConfig = "set -g @yank_with_mouse off ";
      }
      open
    ];
    extraConfig = ''
      set -g mouse on
      set -g -a terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      unbind v
      unbind h
      unbind % # Split vertically
      unbind '"' # Split horizontally
      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"
      bind-key ! break-pane -d

      # Instead of vim-tmux-navigator plugin
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n M-h if-shell "$is_vim" "send-keys M-h"  "select-pane -L"
      bind-key -n M-j if-shell "$is_vim" "send-keys M-j"  "select-pane -D"
      bind-key -n M-k if-shell "$is_vim" "send-keys M-k"  "select-pane -U"
      bind-key -n M-l if-shell "$is_vim" "send-keys M-l"  "select-pane -R"
      bind-key -T copy-mode-vi 'M-h' select-pane -L
      bind-key -T copy-mode-vi 'M-j' select-pane -D
      bind-key -T copy-mode-vi 'M-k' select-pane -U
      bind-key -T copy-mode-vi 'M-l' select-pane -R

      ##### VI #####
      set -g status on
      set -g status-justify centre
      set-window-option -g window-status-format "♦"
      set-window-option -g window-status-current-format "♦"
      set-window-option -g mode-keys vi
      set -g status-right ""
      set -g status-left ""
      set -g status-interval 1
      set -g status-position bottom

      set -g status-bg default
      set -g status-fg default
      set-window-option -g window-status-current-style fg=colour1
      set-window-option -g window-status-style fg=colour9
    '';
  };

  home.file.".local/share/fonts/VictorMono".source = ./dots/VictorMono;

  xdg.configFile."tridactyl".source = ./dots/tridactyl;
  xdg.configFile."kitty".source = ./dots/kitty;
  xdg.configFile."nvim".source = ./dots/nvim;
  xdg.configFile."nixpkgs/config.nix".text = "{ allowUnfree = true; }";
  xdg.enable = true;

  services.lorri.enable = true;
  programs.direnv.enable = true;

  xdg.configFile."fsh/q-jmnemonic.ini".source = ./dots/zsh/q-jmnemonic.ini;
  xdg.configFile."zsh/completions/_src".text = ''
    #compdef src
    compdef '_path_files -/ -W ~/src' src
  '';
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
        BIN_DIR         ${config.xdg.dataHome}/zsh/zinit/bin
        HOME_DIR        ${config.xdg.dataHome}/zsh/zinit
        COMPINIT_OPTS   -C
      )
      if ! [[ -d ${config.xdg.dataHome}/zsh/zinit/bin ]]; then
        mkdir -p ${config.xdg.dataHome}/zsh/zinit
        git clone --depth=1 https://github.com/zdharma/zinit.git ${config.xdg.dataHome}/zsh/zinit/bin
      fi
      source ${config.xdg.dataHome}/zsh/zinit/bin/zinit.zsh
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
