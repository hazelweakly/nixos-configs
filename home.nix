{ config, pkgs, ... }:
let dir = config.home.homeDirectory + "/src/personal/nixos-configs";
in with builtins;
with pkgs.lib; {
  programs.fzf = let fd = "fd -HLE .git -c always";
  in {
    enable = true;
    changeDirWidgetCommand = "${fd} -td .";
    changeDirWidgetOptions = [
      "--preview 'exa --group-directories-first --icons --sort time --tree --color always {} | head -200'"
    ];
    defaultCommand = "${fd} -tf 2> /dev/null";
    defaultOptions =
      [ "--color=$__sys_theme --ansi --layout=reverse --inline-info" ];
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

  home.file.".local/share/fonts/VictorMono".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/VictorMono";
  home.file.".task/hooks/on-modify.timetracking".source =
    pkgs.writeShellScript "on-modify-timewarrior" ''
      PATH=${
        pkgs.python3.withPackages (p: [ p.humanfriendly p.isodate ])
      }/bin:$PATH
      exec python ${dir}/dots/task/time-tracking.py
    '';
  home.file.".task/hooks/on-modify.timewarrior".source =
    pkgs.writeShellScript "on-modify-timewarrior" ''
      PATH=${pkgs.python3}/bin:$PATH
      exec python ${pkgs.timewarrior.outPath}/share/doc/timew/ext/on-modify.timewarrior
    '';
  home.file.".timewarrior/extensions/tt".source =
    pkgs.writeShellScript "totals" ''
      PATH=${pkgs.python3.withPackages (p: [ p.dateutil ])}/bin:$PATH
      exec python ${dir}/dots/task/tt.py
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
    report.ready.columns=id,start.active,depends.indicator,project,due.relative,budget,elapsed,description.desc
    report.ready.labels=,,,Project,Due,Left,Spent,Description
    uda.reviewed.type=date
    uda.reviewed.label=Reviewed
    report._reviewed.description=Tasksh review report.  Adjust the filter to your needs.
    report._reviewed.columns=uuid
    report._reviewed.sort=reviewed+,modified+
    report._reviewed.filter=( reviewed.none: or reviewed.before:now-6days ) and ( +PENDING or +WAITING )

    include ~/.task/contexts.txt
    context=no

    # This should be duration but duration doesn't have sane formatting in reports.
    uda.elapsed.label=Time Spent
    uda.elapsed.type=string
    uda.budget.label=Time Left
    uda.budget.type=string

    uda.pl.label=PL
    uda.pl.type=string
    uda.customer.label=Customer
    uda.customer.type=string
  '';

  xdg.enable = true;
  xdg.configFile."tridactyl".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/tridactyl";
  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/kitty";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/nvim";
  xdg.configFile."glirc".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/glirc";
  xdg.configFile."nixpkgs/config.nix".text =
    "{ allowUnfree = true; allowUnsupportedSystem = true; }";
  xdg.configFile."coc/extensions/coc-lua-data/sumneko-lua-ls/bin/Linux/lua-language-server".source =
    pkgs.sumneko-lua-language-server + "/bin/lua-language-server";
  xdg.configFile."coc/extensions/coc-python-data/languageServer".source =
    pkgs.python-language-server + "/lib";

  services.lorri.enable = true;
  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;
  programs.direnv.stdlib = ''
    : ''${XDG_CACHE_HOME:=$HOME/.cache}
    declare -A direnv_layout_dirs
    direnv_layout_dir() {
      echo "''${direnv_layout_dirs[$PWD]:=$(
        echo -n "$XDG_CACHE_HOME"/direnv/layouts/
        echo -n "$PWD" | shasum | cut -d ' ' -f 1
        )}"
    }
  '';

  xdg.configFile."mpv/mpv.conf".text = ''
    hwdec=auto-safe
    vo=gpu
    profile=gpu-hq
  '';
  xdg.configFile."fsh/theme.ini".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/zsh/theme.ini";
  xdg.configFile."zsh/completions/_src".text = ''
    #compdef src
    _path_files -/ -W ~/src
  '';
  xdg.configFile."zsh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/zsh";
  programs.zsh = {
    enable = true;
    envExtra = ''
      setopt no_global_rcs
      skip_global_compinit=1
    '';
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    initExtraBeforeCompInit = ''
      XDG_CACHE_HOME=${config.xdg.cacheHome}
      XDG_DATA_HOME=${config.xdg.dataHome}
      XDG_CONFIG_HOME=${config.xdg.configHome}
      . $XDG_CONFIG_HOME/zsh/config/.zsh-init
    '';
    initExtra = ''
      for f in $XDG_CONFIG_HOME/zsh/config/[0-9][0-9]-*.zsh; do
      . "$f"
      done
    '';
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
      "${pkgs.neuron-notes}/bin/neuron -d ${config.home.homeDirectory}/zettelkasten rib -ws 127.53.54.1:50000 --pretty-urls";
  };
  systemd.user.services.neuron-notes = {
    Install.WantedBy = [ "graphical-session.target" ];
    Service.ExecStart =
      "${pkgs.neuron-notes}/bin/neuron -d ${config.home.homeDirectory}/Documents/notes gen -ws 127.53.54.2:50001 --pretty-urls";
  };
}
