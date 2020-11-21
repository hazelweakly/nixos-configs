{ config, pkgs, ... }:
let sources = import ./nix/sources.nix;
in with builtins;
with pkgs.lib; {
  # nixpkgs = { inherit (pkgs) config overlays; };

  programs.firefox = {
    enable = true;
    package = pkgs.latest.firefox-devedition-bin.override {
      pname = "firefox";
      extraNativeMessagingHosts = [ pkgs.gnomeExtensions.gsconnect ];
    };
    # profiles.hazel-default = {
    #   isDefault = true;
    #   id = 0;
    #   settings = {
    #     "layers.acceleration.force-enabled" = true;
    #      "ui.systemUsesDarkTheme" = 1;
    #     "layers.omtp.enabled" = true;
    #     "layout.display-list.retain" = true;
    #     "gfx.webrender.all" = true;
    #     "gfx.canvas.azure.accelerated" = true;
    #     "layout.css.devPixelsPerPx" = "1.25";
    #     "pdfjs.enableWebGL" = true;
    #     "browser.ctrlTab.recentlyUsedOrder" = false;
    #     "browser.newtab.extensionControlled" = true;
    #     "browser.newtab.privateAllowed" = true;
    #     "accessibility.typeaheadfind.enablesound" = false;
    #     "widget.wayland-dmabuf-webgl.enabled" = true;
    #     "widget.wayland-dmabuf-textures.enabled" = true;
    #     "widget.wayland-dmabuf-vaapi.enabled" = true;
    #     "media.ffvpx.enabled" = false;
    #     "network.http.http3.enabled" = true;
    #     "browser.preferences.experimental" = true;
    #   };
    # };
  };

  programs.fzf = let fd = "fd -HLE .git -c always";
  in {
    enable = true;
    changeDirWidgetCommand = "${fd} -td .";
    changeDirWidgetOptions = [
      "--preview 'exa --group-directories-first --icons --sort time --tree --color always {} | head -200'"
    ];
    defaultCommand = "${fd} -tf 2> /dev/null";
    defaultOptions = [ "--color=$__sys_theme --ansi --layout=reverse" ];
    fileWidgetCommand = "${fd} .";
    fileWidgetOptions = let
      preview =
        "(bat --style numbers,changes --color always --paging never {} || tree -C {}) 2> /dev/null";
    in [ "--preview '${preview} | head -200'" ];
    historyWidgetOptions = [''
      --preview 'echo {} | cut -d\" \" -f2- | fold -w $(($(tput cols)-4))' --preview-window down:4:hidden --bind '?:toggle-preview'
    ''];
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
      set -g default-terminal "tmux-256color"
      set -g mouse on
      set -as terminal-overrides ",*:Tc:RGB"

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
  home.file.".task/hooks/on-modify.timewarrior".source =
    pkgs.writeShellScript "on-modify-timewarrior" ''
      PATH=${pkgs.python3.withPackages (p: [ p.dateutil ])}/bin:$PATH
      exec python ${pkgs.timewarrior.outPath}/share/doc/timew/ext/on-modify.timewarrior
    '';
  home.file.".timewarrior/extensions/totals.py".source =
    pkgs.writeShellScript "totals" ''
      PATH=${pkgs.python3.withPackages (p: [ p.dateutil ])}/bin:$PATH
      exec python ${pkgs.timewarrior.outPath}/share/doc/timew/ext/totals.py
    '';
  home.file.".taskrc".text = ''
    data.location=~/.task

    include ${pkgs.taskwarrior.outPath}/share/doc/task/rc/no-color.theme
    include ~/.task/current.theme

    journal.time=on

    # Shortcuts
    alias.dailystatus=status:completed end.after:today all
    alias.punt=modify wait:1d
    alias.meh=modify due:tomorrow
    alias.someday=mod +someday wait:someday

    search.case.sensitive=no
    alias.burndown=burndown.daily

    # task ready report default with custom columns
    default.command=ready
    report.ready.columns=id,start.active,depends.indicator,project,due.relative,description.desc
    report.ready.labels= ,,Depends, Project, Due, Description
  '';

  # xdg.configFile."direnv/direnvrc".text = ''
  #  source /run/current-system/sw/share/nix-direnv/direnvrc
  # : ${XDG_CACHE_HOME:=$HOME/.cache}
  # pwd_hash=$(echo -n $PWD | shasum | cut -d ' ' -f 1)
  # direnv_layout_dir=$XDG_CACHE_HOME/direnv/layouts/$pwd_hash
  # '';
  xdg.configFile."tridactyl".source = ./dots/tridactyl;
  xdg.configFile."kitty" = {
    source = ./dots/kitty;
    recursive = true;
  };
  xdg.configFile."nvim" = {
    source = ./dots/nvim;
    recursive = true;
  };
  xdg.configFile."glirc".source = ./dots/glirc;
  xdg.configFile."nixpkgs/config.nix".text =
    "{ allowUnfree = true; allowUnsupportedSystem = true; }";
  xdg.enable = true;
  xdg.configFile."coc/extensions/coc-python-data/languageServer".source =
    pkgs.python-language-server + "/lib";

  services.lorri.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  xdg.configFile."fsh/theme.ini".source = ./dots/zsh/theme.ini;
  xdg.configFile."zsh/completions/_src".text = ''
    #compdef src
    compdef '_path_files -/ -W ~/src' src
  '';
  programs.zsh = let
    zshrc' = concatMapStringsSep "\n" (n: readFile (./dots/zsh + "/${n}"))
      (filter (hasSuffix ".zsh") (attrNames (readDir ./dots/zsh)));
    zshrc = builtins.replaceStrings [ "@zsh-prompt@" ]
      [ "${builtins.toString ./dots/zsh/30-prompt.zsh}" ] zshrc';
  in {
    enable = true;
    envExtra = "setopt no_global_rcs";
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraBeforeCompInit = ''
      DISABLE_MAGIC_FUNCTIONS="true"
      if [[ -r "${config.xdg.dataHome}/theme" ]]; then
        export __sys_theme="$(<${config.xdg.dataHome}/theme)"
      fi
      if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      typeset -A ZPLGM=(
        BIN_DIR         ${config.xdg.dataHome}/zsh/zinit/bin
        HOME_DIR        ${config.xdg.dataHome}/zsh/zinit
        COMPINIT_OPTS   -C
      )
      if ! [[ -d ${config.xdg.dataHome}/zsh/zinit/bin ]]; then
        command mkdir -p ${config.xdg.dataHome}/zsh/zinit
        command git clone --depth=1 https://github.com/zdharma/zinit.git ${config.xdg.dataHome}/zsh/zinit/bin
      fi
      source ${config.xdg.dataHome}/zsh/zinit/bin/zinit.zsh
      if ! [[ -f ${config.xdg.dataHome}/zsh/zinit/bin/zmodules/COMPILED_AT ]]; then
        nix-shell -p clang ncurses autoconf --run 'zsh -ilc "zinit module build"'
      fi
      module_path+=("${config.xdg.dataHome}/zsh/zinit/bin/zmodules/Src")
      zmodload zdharma/zplugin &>/dev/null
      autoload -Uz _zinit
      (( ''${+_comps} )) && _comps[zinit]=_zinit
    '';
    initExtra = zshrc;
  };

  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
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

  systemd.user.services.neuron = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart =
      "${pkgs.neuron}/bin/neuron -d ${config.home.homeDirectory}/zettelkasten rib -wS";
  };
}
