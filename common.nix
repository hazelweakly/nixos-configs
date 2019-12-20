with {
  pkgs = import ./nix { };
  sources = import ./nix/sources.nix;
}; {
  imports = [
    "${sources.nixos-hardware}/common/cpu/intel"
    "${sources.nixos-hardware}/common/pc/ssd"
    "${sources.nixos-hardware}/common/pc/laptop"
    "${sources.home-manager}/nixos"
    ./cachix.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;

  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.hostName = "hazelweaklyeakly";
  networking.firewall.enable = false;

  i18n = {
    consoleFont = "latarcyrheb-sun20";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" ];
  };

  time.timeZone = "America/Los_Angeles";

  nix.trustedUsers = [ "hazel" ];

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [ noto-fonts noto-fonts-cjk noto-fonts-emoji ];
    fontconfig = {
      # hinting.enable = false;
      # antialias = false;
      # subpixel.lcdfilter = "none";
      defaultFonts = {
        monospace = ["PragmataPro"];
        sansSerif = ["Noto Sans"];
        serif = ["Noto Serif"];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # Actually global
    lastpass-cli
    google-chrome
    firefox-devedition-bin
    git
    calibre
    kitty
    cachix

    # Stuff relied on by my nvim configs
    neovim-remote
    nodePackages.neovim
    python37Packages.pynvim
    python3
    ((neovim.override { withNodeJs = true; }).passthru.unwrapped.overrideAttrs
      (o: {
        version = "master";
        src = sources.neovim;
        buildInputs = o.buildInputs ++ [ utf8proc ];
      }))
    nixfmt
    yarn
    nodejs_latest
    universal-ctags

    # ncurses

    # ((import sources.all-hies { }).selection {
    #   selector = p: { inherit (p) ghc865; };
    # })
    # (import sources.ghcide-nix { }).ghcide-ghc865
    direnv

    # Programs implicitly relied on in shell
    lsd
    bat
    fd
    fzf
    ripgrep
  ];

  environment.variables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    VISUAL = "nvim";
    EDITOR = "nvim";
    # Scroll with a toushcreen in firefox
    MOZ_USE_XINPUT2 = "1";
    # Relied on by my nvim configs
    # RUST_SRC_PATH = "${
    #     (pkgs.latest.rustChannels.nightly.rust.override {
    #       extensions = [ "rust-src" ];
    #     })
    #   }/lib/rustlib/src/rust/src";
  };

  programs.ssh.startAgent = true;
  programs.zsh = {
    enable = true;
    enableCompletion = false;
    promptInit = "";
  };

  services.thermald.enable = true;
  services.interception-tools.enable = true;
  services.system-config-printer.enable = true;
  services.printing.enable = true;
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  location.provider = "geoclue2";
  services.redshift = {
    enable = true;
    temperature = {
      day = 6500;
      night = 2300;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    autoRepeatDelay = 240;
    autoRepeatInterval = 30;

    libinput = {
      naturalScrolling = true;
      disableWhileTyping = true;
      accelSpeed = "0.5";
    };

    displayManager.gdm = {
      enable = true;
      autoLogin = {
        enable = true;
        user = "hazel";
      };
    };

    desktopManager.gnome3.enable = true;

    # TODO: Figure out how to get this done with
    # keeping plasma because I'll lose too much time replicating plasma's setup
    # wrt stuff like NetworkManager, printer, etc. *sigh* whatevs. The
    # convenience is worth losing some street cred I suppose.

    # desktopManager.default = "none";
    # desktopManager.xterm.enable = false;
    # windowManager.default = "xmonad";
    # windowManager.xmonad = {
    #   enable = true;
    #   enableContribAndExtras = true;
    #   haskellPackages = pkgs.unstable.haskellPackages;
    #   config = /home/hazel/.config/xmonad/xmonad.hs;
    # };
    # displayManager.sessionCommands = lib.mkAfter ''
    #   ${pkgs.unstable.xorg.xset}/bin/xset r rate 240 30
    # '';

  };

  virtualisation.docker.enable = true;

  users.users.hazel = {
    isNormalUser = true;
    home = "/home/hazel";
    shell = pkgs.zsh;
    extraGroups =
      [ "wheel" "networkmanager" "tty" "video" "audio" "disk" "docker" ];
  };

  # Use pkgs from system closure by ignoring input args
  home-manager.users.hazel = { ... }:
    let
      lorri = import sources.lorri { };
      path = with pkgs; lib.makeSearchPath "bin" [ nix gnutar git mercurial ];
    in {

      home.packages = [ lorri ];

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

      systemd.user.sockets.lorri = {
        Unit = { Description = "lorri build daemon"; };
        Socket = { ListenStream = "%t/lorri/daemon.socket"; };
        Install = { WantedBy = [ "sockets.target" ]; };
      };

      systemd.user.services.lorri = {
        Unit = {
          Description = "lorri build daemon";
          Documentation = "https://github.com/target/lorri";
          ConditionUser = "!@system";
          Requires = "lorri.socket";
          After = "lorri.socket";
          RefuseManualStart = true;
        };

        Service = {
          ExecStart = "${lorri}/bin/lorri daemon";
          PrivateTmp = true;
          ProtectSystem = "strict";
          WorkingDirectory = "%h";
          Restart = "on-failure";
          Environment = "PATH=${path} RUST_BACKTRACE=1";
        };
      };
    };

  system.autoUpgrade.enable = true;
  nix.optimise.automatic = true;
}
