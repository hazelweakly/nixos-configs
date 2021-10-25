{ config, pkgs, ... }:
let dir = config.home.homeDirectory + "/src/personal/nixos-configs";
in
with builtins;
with pkgs.lib; {
  home.stateVersion = "21.11";

  programs.fzf =
    let fd = "fd -HLE .git -c always";
    in
    {
      enable = true;
      changeDirWidgetCommand = "${fd} -td .";
      changeDirWidgetOptions = [
        "--preview 'exa --group-directories-first --icons --sort time --tree --color always {} | head -200'"
      ];
      defaultCommand = "${fd} -tf 2> /dev/null";
      defaultOptions =
        [ "--color=$__sys_theme --ansi --layout=reverse --inline-info" ];
      fileWidgetCommand = "${fd} .";
      fileWidgetOptions =
        let
          preview =
            "(bat --style numbers,changes --color always --paging never {} || tree -C {}) 2> /dev/null";
        in
        [ "--preview '${preview} | head -200'" ];
      historyWidgetOptions = [
        ''
          --preview 'echo {} | cut -d\" \" -f2- | fold -w $(($(tput cols)-4))' --preview-window down:4:hidden --bind '?:toggle-preview'
        ''
      ];
    };

  home.homeDirectory = mkForce "/Users/hazelweakly";
  xdg.enable = true;

  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/kitty";
  xdg.configFile."ranger".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/ranger";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/nvim";
  xdg.configFile."nixpkgs/config.nix".text =
    "{ allowUnfree = true; allowUnsupportedSystem = true; }";

  programs.nix-index.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.enableFlakes = true;
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

  programs.info.enable = true;

  xdg.configFile."zsh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/zsh";
  programs.zsh = {
    enable = true;
    envExtra = ''
      unsetopt GLOBAL_RCS
      skip_global_compinit=1

      if [ -n "''${ZSH_VERSION-}" ]; then
        : ''${ZDOTDIR:=~/.config/zsh}
        setopt no_global_rcs
        [[ -o no_interactive && -z "''${Z4H_BOOTSTRAPPING-}" ]] && return
        setopt no_rcs
        unset Z4H_BOOTSTRAPPING
      fi

      Z4H_URL="https://raw.githubusercontent.com/romkatv/zsh4humans/v5"
      : "''${Z4H:=''${XDG_CACHE_HOME:-$HOME/.cache}/zsh4humans/v5}"

      if [ ! -e "$Z4H"/z4h.zsh ]; then
        mkdir -p -- "$Z4H" || return
        >&2 printf '\033[33mz4h\033[0m: fetching \033[4mz4h.zsh\033[0m\n'
        if command -v curl >/dev/null 2>&1; then
          curl -fsSL -- "$Z4H_URL"/z4h.zsh >"$Z4H"/z4h.zsh.$$ || return
        elif command -v wget >/dev/null 2>&1; then
          wget -O-   -- "$Z4H_URL"/z4h.zsh >"$Z4H"/z4h.zsh.$$ || return
        else
          >&2 printf '\033[33mz4h\033[0m: please install \033[32mcurl\033[0m or \033[32mwget\033[0m\n'
          return 1
        fi
        mv -- "$Z4H"/z4h.zsh.$$ "$Z4H"/z4h.zsh || return
      fi

      . "$Z4H"/z4h.zsh || return

      setopt rcs
    '';
    dotDir = ".config/zsh";
    enableCompletion = true;
    defaultKeymap = "emacs";
    history.path = "${config.xdg.cacheHome}/.zsh_history";
    completionInit = "";
    initExtraBeforeCompInit = ''
      XDG_DATA_HOME=${config.xdg.dataHome}
      XDG_CONFIG_HOME=${config.xdg.configHome}
      . $XDG_CONFIG_HOME/zsh/config/theme.zsh
    '';
    initExtra = ''
      __fzf_dir=${pkgs.fzf}
      . $XDG_CONFIG_HOME/zsh/config/.zsh-init
      unset __fzf_dir
    '';
  };

  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
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
