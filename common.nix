{ pkgs, inputs, ... }: {
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
    experimental-features = nix-command flakes ca-references
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 50;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.tmpOnTmpfs = true;
  boot.plymouth.enable = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # recommended settings from lxd nixos module
  boot.kernel.sysctl = {
    "fs.inotify.max_queued_events" = 1048576;
    "fs.inotify.max_user_instances" = 1048576;
    "fs.inotify.max_user_watches" = 1048576;
    "vm.max_map_count" = 262144;
    "kernel.dmesg_restrict" = 1;
    "net.ipv4.neigh.default.gc_thresh3" = 8192;
    "net.ipv6.neigh.default.gc_thresh3" = 8192;
    "kernel.keys.maxkeys" = 2000;
  };

  console.font = "latarcyrheb-sun32";
  console.keyMap = "us";
  i18n.extraLocaleSettings.LC_ALL = "en_US.UTF-8";

  time.timeZone = "America/Los_Angeles";

  nix.trustedUsers = [ "hazel" ];

  fonts = let luxi = pkgs.callPackage ./luxi.nix { };
  in {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      powerline-fonts
      corefonts
      luxi
      eb-garamond
    ];
    fontconfig.defaultFonts = {
      monospace = [ "VictorMono Nerd Font" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  environment.systemPackages = with pkgs;
    let
      # p = mach-nix.mkPython { requirements = "papis-zotero"; };
      # papis-exts = stdenv.mkDerivation {
      #   name = "papis-exts";
      #   src = "";
      #   phases = [ "buildPhase" ];
      #   buildPhase = ''
      #     sp=lib/${p.executable}/site-packages; mkdir -p $out/bin $out/$sp
      #     for e in ${p.outPath}/bin/papis-*; do ln -s $e $out/bin; done
      #     for l in ${p.outPath}/$sp/{papis_*,zotero}; do ln -s $l $out/$sp; done
      #   '';
      # };
      nxr = pkgs.writeScriptBin "nxr" ''
        #!${pkgs.runtimeShell}
        exec ${pkgs.nixUnstable}/bin/nix repl ${inputs.utils.lib.repl}
      '';

      bitwarden-wrapper = let
        path = pkgs.lib.makeBinPath
          (with pkgs; [ coreutils utillinux bitwarden-cli systemd gnused ]);
        bw = pkgs.writeShellScriptBin "bw" ''
          export PATH=${path};
          token_file=/run/user/$(id -u)/bw-token
          lock_file=/run/user/$(id -u)/bw-token.lock

          export DISPLAY="$(systemctl --user show-environment | sed 's/^DISPLAY=\(.*\)/\1/; t; d')"

          if [[ -e "$token_file" ]]; then
            export BW_SESSION=$(<"$token_file")
          else
            exec 9>"$lock_file"
            while ! flock -n 9; do
              sleep 1
            done
            if [[ -e "$token_file" ]]; then
              export BW_SESSION=$(<"$token_file")
            else
              for i in $(seq 1 4); do
                export BW_SESSION=$(bw unlock --raw)
                if [[ "$BW_SESSION" != "" ]]; then
                  echo "$BW_SESSION" > "$token_file"
                  break
                fi
              done
            fi
          fi

          exec bw "$@"
        '';
      in bw.overrideAttrs (o: {
        buildCommand = o.buildCommand + ''
          runHook postInstall
        '';
        postInstall = ''
          mkdir -p $out/share/zsh/site-functions
          HOME=.
          ${pkgs.bitwarden-cli}/bin/bw completion --shell zsh > $out/share/zsh/site-functions/_bw
        '';
        nativeBuildInputs = (o.nativeBuildInputs or [ ])
          ++ [ pkgs.installShellFiles ];
      });
    in [
      # Actually global
      bitwarden-wrapper
      google-chrome
      kitty
      cachix
      firefox-nightly-bin
      file
      timewarrior
      taskwarrior
      tasksh
      taskopen
      mupdf
      niv
      (callPackage ./neovim.nix { })
      zoom-us
      neuron-notes
      obelisk.command
      awscli2
      ssm-session-manager-plugin
      alacritty
      ranger
      mach-nix.mach-nix
      # papis
      # papis-exts
      manix
      nxr

      # Programs implicitly relied on in shell
      pistol
      exa
      gitAndTools.delta
      bat
      fd
      ripgrep
    ];

  environment.variables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
    VISUAL = "nvim";
    EDITOR = "nvim";
    MOZ_USE_XINPUT2 = "1";
    MOZ_X11_EGL = "1";
  };

  programs.ssh.startAgent = true;
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
  programs.adb.enable = true;
  programs.gnupg.agent.enable = true;

  services.thermald.enable = true;
  services.interception-tools.enable = pkgs.lib.mkDefault true;
  services.system-config-printer.enable = true;
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    canon-cups-ufr2
    brlaser
  ];
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  services.fwupd.enable = true;

  location.provider = "geoclue2";
  services.redshift = {
    enable = false;
    temperature = {
      day = 6500;
      night = 2300;
    };
  };

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.enableRedistributableFirmware = pkgs.lib.mkDefault true;
  hardware.enableAllFirmware = true;
  services.tlp.enable = false;
  hardware.opengl.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];

  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl";
    autoRepeatDelay = 190;
    autoRepeatInterval = 35;

    libinput.touchpad = {
      naturalScrolling = true;
      disableWhileTyping = true;
      accelSpeed = "0.5";
      calibrationMatrix = ".5 0 0 0 .5 0 0 0 1";
    };
    inputClassSections = [
      ''
        Identifier "Enable libinput for touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
      ''
      ''
        Identifier "Enable libinput for pointer"
        MatchIsPointer "on"
        Driver "libinput"
      ''
    ];

    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "hazel";
    displayManager.gdm = {
      enable = true;
      autoSuspend = true;
      wayland = false;
    };
    displayManager.setupCommands = ''
      stty -ixon
      unset __NIXOS_SET_ENVIRONMENT_DONE
    '';

    desktopManager.gnome.enable = true;
    desktopManager.gnome.sessionPath = [ pkgs.gnomeExtensions.pop-os ];
    # windowManager.xmonad = {
    #   enable = true;
    #   enableContribAndExtras = true;
    #   haskellPackages = pkgs.haskellPackages;
    #   # This breaks mod+Q to reload config
    #   config = ./dots/xmonad/xmonad.hs;
    # };
  };

  # Need to set keyring password to blank?
  security.pam.services.gdm.enableGnomeKeyring = true;

  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  environment.etc."docker/daemon.json".text =
    ''{ "features": { "buildkit": true } }'';

  virtualisation.oci-containers.containers."explainshell" = {
    image = "spaceinvaderone/explainshell";
    ports = [ "5000:5000" ];
  };

  environment.etc.zoneinfo.source = pkgs.lib.mkForce "${
      pkgs.tzdata.overrideAttrs (old: {
        makeFlags = old.makeFlags
          ++ [ ''CFLAGS+=-DZIC_BLOAT_DEFAULT=\"fat\"'' ];
      })
    }/share/zoneinfo";

  virtualisation.libvirtd.enable = false;
  virtualisation.libvirtd.onBoot = "ignore";
  virtualisation.virtualbox.host.enable = false;
  boot.extraModprobeConfig = "options kvm_intel nested=1";

  nix.optimise.automatic = true;
}
