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

  xdg.configFile."fsh/theme.ini".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/zsh/theme.ini";
  xdg.configFile."zsh/completions/_src".text = ''
    #compdef src
    _path_files -/ -W ~/src
  '';
  xdg.configFile."zsh/completions/_mcd".text = ''
    #compdef mcd
    _directories
  '';
  xdg.configFile."zsh/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/zsh";
  programs.zsh = {
    enable = true;
    envExtra = ''
      unsetopt GLOBAL_RCS
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
}
