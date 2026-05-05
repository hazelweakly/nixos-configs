{ config, lib, userProfile, systemProfile, pkgs, ... }: lib.mkMerge [
  {
    home.stateVersion = "26.05";
    home.username = userProfile.name;
    home.homeDirectory = lib.mkForce userProfile.home;
    xdg.enable = true;

    xdg.configFile."kitty".source =
      config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/kitty";
    xdg.configFile."ranger".source =
      config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/ranger";
    xdg.configFile."nvim".source =
      config.lib.file.mkOutOfStoreSymlink "${userProfile.flakeDir}/dots/nvim";
    home.file.".hushlogin".text = "";

    xdg.configFile."nixpkgs/config.nix".text =
      ''{ allowUnfree = true; allowUnsupportedSystem = true; }'';

    programs.info.enable = true;
    programs.nix-index.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.direnv.enableZshIntegration = true;
    programs.direnv.silent = true;
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
  (lib.optionalAttrs (systemProfile.isWork) {
    targets.darwin.copyApps.enable = true;
    targets.darwin.linkApps.enable = false;
  })
  (lib.optionalAttrs (!systemProfile.isWork) {
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
  })
] // {
  imports = [
    ../fzf.nix
    ../git.nix
    ../neovim.nix
    # ../work.nix
    ../zsh.nix
  ]
  ++ (lib.optionals (!systemProfile.isWork) [
    ../dark-mode-notify.nix
    ../gtk.nix
    ../task.nix
  ]);
}
