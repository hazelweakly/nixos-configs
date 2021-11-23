{ pkgs, config, ... }:
let dir = config.home.homeDirectory + "/src/personal/nixos-configs";
in
with builtins;
with pkgs.lib; {
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
    history.path = "${config.xdg.configHome}/zsh/.zsh_history";
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
}