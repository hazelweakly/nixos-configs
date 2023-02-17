{ config, pkgs, lib, userProfile, ... }: {
  home.stateVersion = "22.11";
  home.username = userProfile.name;
  home.homeDirectory = lib.mkForce userProfile.home;
  xdg.enable = true;

  imports = [
    ../dark-mode-notify.nix
    ../fzf.nix
    ../git.nix
    ../neovim.nix
    ../nix.nix
    ../task.nix
    ../work.nix
    ../zsh.nix
    ../../modules/age.nix
  ];

  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/kitty";
  xdg.configFile."ranger".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/ranger";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/nvim";
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
