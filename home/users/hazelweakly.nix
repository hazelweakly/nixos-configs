{ config, pkgs, profiles, ... }:
let dir = config.home.homeDirectory + "/src/personal/nixos-configs";
in
with builtins;
with pkgs.lib; {
  home.stateVersion = "22.11";
  home.username = profiles.user.username;
  home.homeDirectory = mkForce "/Users/${profiles.user.username}";
  xdg.enable = true;

  imports = [ ../task.nix ../fzf.nix ../zsh.nix ../git.nix ../neovim.nix ];

  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/kitty";
  xdg.configFile."ranger".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/ranger";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dir}/dots/nvim";
  xdg.configFile."isort.cfg".text = ''
    [isort]
    profile = black
  '';
  xdg.configFile."nixpkgs/config.nix".text =
    "{ allowUnfree = true; allowUnsupportedSystem = true; }";

  programs.info.enable = true;
  programs.nix-index.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
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
}
