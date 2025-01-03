{ config, lib, userProfile, pkgs, ... }: {
  home.stateVersion = "22.11";
  home.username = userProfile.name;
  home.homeDirectory = lib.mkForce userProfile.home;
  xdg.enable = true;

  imports = [
    ../dark-mode-notify.nix
    ../fzf.nix
    ../git.nix
    ../gtk.nix
    ../../modules/age.nix
    ../neovim.nix
    ../task.nix
    ../work.nix
    ../zsh.nix
  ];

  xdg.configFile."kitty".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/kitty";
  xdg.configFile."ranger".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/ranger";
  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/nvim";
  home.file.".hushlogin".text = "";
  xdg.configFile."tridactyl".source =
    config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/tridactyl";
  home.file."Library/Application Support/Claude/claude_desktop_config.json".text =
    let
      path = ''
        "PATH": "${lib.concatStringsSep ":" [
              (lib.makeBinPath [pkgs.nodejs_latest])
              "/run/current-system/sw/bin"
              "/etc/profiles/per-user/${userProfile.name}/bin"
              "/bin"
              "/opt/homebrew/bin"
              "/System/Cryptexes/App/usr/bin"
              "/usr/local/bin"
              "/usr/bin"
              "/usr/sbin"
              "/sbin"
            ]}"
      '';
    in
    ''
      {
        "mcpServers": {
          "memory": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-memory"],
            "env": {${path}}
          },
          "filesystem": {
            "command": "npx",
            "args": ["-y", "@modelcontextprotocol/server-filesystem", "${userProfile.home}/src/personal"],
            "env": {${path}}
          }
        }
      }
    '';

  home.activation.us-keyboard = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cp -R "${userProfile.flakeDir}/dots/US No Dead Keys.bundle" ~/Library/"Keyboard Layouts"
  '';

  xdg.configFile."isort.cfg".text = ''
    [isort]
    profile = black
  '';
  xdg.configFile."nixpkgs/config.nix".text =
    ''{ allowUnfree = true; allowUnsupportedSystem = true; }'';
  # ''{ allowUnfree = true; allowUnsupportedSystem = true; permittedInsecurePackages = [ "xpdf-4.04" ]; }'';

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
