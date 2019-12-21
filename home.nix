{ ... }:
with { pkgs = import ./nix { }; }; {
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
      };
    };
    # TODO: Figure out why tridactyl won't install nicely
  };

  xdg.configFile."tridactyl/tridactylrc".source = ./dots/tridactylrc;

  services.lorri.enable = true;
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  # programs.rofi = {
  #   enable = true;
  #   font = "Pragmata Pro 11";
  #   fullscreen = true;
  #   extraConfig = ''
  #     rofi.theme: ./onelight.rasi
  #   '';
  # };

  # home.file.".config/autostart/plasmashell.desktop".text = ''
  #   [Desktop Entry]
  #   Exec=
  #   X-DBUS-StartupType=Unique
  #   Name=Plasma Desktop Workspace
  #   Type=Application
  #   X-KDE-StartupNotify=false
  #   X-DBUS-ServiceName=org.kde.plasmashell
  #   OnlyShowIn=KDE;
  #   X-KDE-autostart-phase=0
  #   Icon=plasma
  #   NoDisplay=true
  # '';
  # home.file.".local/share/xmonad/touch".text = "";
  # home.file.".config/plasma-workspace/env/set_window_manager.sh".text = ''
  #   export KDEWM=/home/hazel/.local/share/xmonad/xmonad-x86_64-linux
  # '';

  programs.git = {
    enable = true;
    userName = "hazelweakly";
    userEmail = "hazel@theweaklys.com";
    package = pkgs.gitAndTools.gitFull;
    extraConfig = {
      core = { pager = "diff-so-fancy | less --tabs=4 -RFX"; };
      color = {
        ui = true;
        diff-highlight = {
          oldNormal = "red bold";
          oldHighlight = "red bold 52";
          newNormal = "green bold";
          newHighlight = "green bold 22";
        };
        diff = {
          meta = "11";
          frag = "magenta bold";
          commit = "yellow bold";
          old = "red bold";
          new = "green bold";
          whitespace = "red reverse";
        };
      };
    };
  };
}
