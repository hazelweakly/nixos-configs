{
  description = "Hazel's system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    digga.url = "github:divnix/digga/develop";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
      inputs.flake-utils.follows = "flake-utils";
    };
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-firefox-nightly = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neuron = {
      url = "github:srid/neuron";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    taskwarrior = {
      url = "https://github.com/GothenburgBitFactory/taskwarrior.git";
      type = "git";
      ref = "2.6.0";
      submodules = true;
      flake = false;
    };
    obelisk = {
      url = "github:obsidiansystems/obelisk";
      flake = false;
    };
    dynamic-wallpaper = {
      url = "github:adi1090x/dynamic-wallpaper";
      flake = false;
    };
    pop-os-shell = {
      url = "github:pop-os/shell";
      flake = false;
    };
    pop-os-shell-shortcuts = {
      url = "github:pop-os/shell-shortcuts";
      flake = false;
    };
    night-theme-switcher = {
      url = "gitlab:/rmnvgr/nightthemeswitcher-gnome-shell-extension/v50";
      flake = false;
    };
    matterhorn = {
      url = "github:matterhorn-chat/matterhorn";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , utils
    , home-manager
    , nixos-hardware
    , neovim-flake
    , mach-nix
    , taskwarrior
    , neuron
    , obelisk
    , pop-os-shell
    , pop-os-shell-shortcuts
    , night-theme-switcher
    , flake-utils
    , flake-firefox-nightly
    , rust-overlay
    , agenix
    , ...
    }:
    let
      moz' = self: super:
        let
          mapAttrs = super.stdenv.lib.mapAttrs;
          flip = super.stdenv.lib.flip;
        in
        {
          latest = super.latest // {
            rustChannels = flip mapAttrs super.latest.rustChannels (
              _: value:
                value // {
                  rust = value.rust.override { extensions = [ "rust-src" ]; };
                }
            );
          };
        };
      neuron-notes = _: _: {
        neuron-notes = neuron.defaultPackage.x86_64-linux;
      };
      obelisk = _: _: {
        obelisk = import inputs.obelisk { system = "x86_64-linux"; };
      };
      gnomeExts = _: super: {
        pop-shell-shortcuts = super.rustPlatform.buildRustPackage rec {
          pname = "pop-shell-shortcuts";
          version = "2020-09-28";
          src = pop-os-shell-shortcuts;
          cargoSha256 = "sha256-kuaepwKsNHRH4SFLNrQhy1CTPR/HcpVuTyzuTPDaKQI=";
          nativeBuildInputs = [ super.pkg-config ];
          buildInputs = [ super.gtk3 super.glib ];
        };

        gnomeExtensions = super.gnomeExtensions // {
          pop-os = super.stdenv.mkDerivation rec {
            pname = "gnome-shell-extension-pop-os-shell";
            version = "master";
            src = pop-os-shell;
            uuid = "pop-shell@system76.com";
            nativeBuildInputs = [
              super.glib
              super.nodePackages.typescript
              super.gjs

              super.wrapGAppsHook
              super.gobject-introspection
            ];
            patches = [ ./fix-gjs.patch ];
            buildInputs = [ super.gobject-introspection super.gjs ];
            makeFlags = [
              "INSTALLBASE=$(out)/share/gnome-shell/extensions PLUGIN_BASE=$(out)/share/pop-shell/launcher SCRIPTS_BASE=$(out)/share/pop-shell/scripts"
            ];
            postInstall = ''
                chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/floating_exceptions/main.js
                chmod +x $out/share/gnome-shell/extensions/pop-shell@system76.com/color_dialog/main.js

                mkdir -p $out/share/gnome-control-center/keybindings
                cp -r keybindings/*.xml $out/share/gnome-control-center/keybindings

                mkdir -p $out/share/gsettings-schemas/pop-shell-${version}/glib-2.0
                schemadir=${
              super.glib.makeSchemaPath "$out" "${pname}-${version}"
              }
                mkdir -p $schemadir
                cp -r $out/share/gnome-shell/extensions/$uuid/schemas/* $schemadir
            '';
          };
          night-theme-switcher =
            super.gnomeExtensions.night-theme-switcher.overrideAttrs (
              o: {
                version = "50";
                src = night-theme-switcher;
              }
            );
        };
      };
      intel = _: super: {
        vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
      };
      ffox = self: super:
        let
          n =
            flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin.name;

          policies = {
            DisableAppUpdate = true;
            SecurityDevices = {
              p11-kit = "${self.p11-kit}/lib/pkcs11/p11-kit-trust.so";
            };
          };
        in
        rec {
          firefox-nightly-bin =
            super.wrapFirefox (firefox-nightly-bin-unwrapped) {
              browserName = "firefox";
              pname = "firefox-bin";
              desktopName = "Firefox";
              firefoxLibName = "${n}";
              extraPolicies = policies;
              extraPrefs = ''
                defaultPref("accessibility.typeaheadfind.enablesound", false);
                defaultPref("accessibility.typeaheadfind.flashBar", 0);
                defaultPref("browser.aboutConfig.showWarning", false);
                defaultPref("browser.ctrlTab.recentlyUsedOrder", false);
                defaultPref("browser.in-content.dark-mode", true);
                defaultPref("browser.proton.enabled", true);
                defaultPref("browser.startup.homepage","about:blank");
                defaultPref("browser.urlbar.keepPanelOpenDuringImeComposition", true);
                defaultPref("gfx.webrender.all", true);
                defaultPref("gfx.webrender.enabled", true);
                defaultPref("gfx.webrender.software", false);
                defaultPref("javascript.options.warp", true);

                defaultPref("layers.gpu-process.enabled", true);
                defaultPref("dom.webgpu.enabled", true);

                defaultPref("layout.css.devPixelsPerPx", "1.4");
                defaultPref("media.ffmpeg.vaapi.enabled", true);
                defaultPref("media.ffvpx.enabled", false);
                defaultPref("network.dns.disablePrefetch", false);
                defaultPref("network.dns.disablePrefetchFromHTTPS", false);
                defaultPref("network.http.http3.enable_qlog", true);
                defaultPref("network.http.speculative-parallel-limit", 20);
                defaultPref("network.predictor.enable", true);
                defaultPref("network.prefetch-next", true);
                defaultPref("pdfjs.enabledCache.state", true);
                defaultPref("pdfjs.enableWebGL", true);
              '';
            };
          firefox-nightly-bin-unwrapped =
            let
              policiesJSON = super.writeText "policy.json"
                (builtins.toJSON { inherit policies; });
            in
            flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin.unwrapped.overrideAttrs
              (
                o: {
                  installPhase = (o.installPhase or "") + ''
                    ln -sf ${self.p11-kit}/lib/pkcs11/p11-kit-trust.so $out/lib/${n}/libnssckbi.so
                    ln -sf ${policiesJSON} $out/lib/${n}/distribution/policies.json
                  '';
                }
              );
        };
      task = _: super: {
        taskwarrior = super.taskwarrior.overrideAttrs (
          o: rec {
            version = "2.6.0";
            src = inputs.taskwarrior;
            postInstall = ''
              mkdir -p "$out/share/bash-completion/completions"
              ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
              mkdir -p "$out/share/fish/vendor_completions.d"
              ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/task.fish"
              mkdir -p "$out/share/zsh/site-functions"
              ln -s "../../../share/doc/task/scripts/zsh/_task" "$out/share/zsh/site-functions/_task"
            '';
          }
        );
      };
      overlays = [
        neuron-notes
        (
          final: prev: {
            neovim-nightly = neovim-flake.packages.${prev.system}.neovim;
          }
        )
        (
          _: _: {
            mach-nix = mach-nix.packages.x86_64-linux.mach-nix // {
              mach-nix = mach-nix.packages.x86_64-linux.mach-nix;
            } // mach-nix.lib.x86_64-linux;
          }
        )
        moz'
        gnomeExts
        intel
        ffox
        rust-overlay.overlay
        task
        obelisk
      ];
    in
    utils.lib.systemFlake {
      inherit self inputs;
      channels.nixpkgs.input = nixpkgs;
      channelsConfig.allowUnfree = true;
      channelsConfig.permittedInsecurePackages = [ "ffmpeg-3.4.8" ];

      hosts.hazelweakly.modules = [
        ./machines/nvidia.nix
        ./machines/precision7740.nix
        agenix.nixosModules.age
        (
          { config, ... }: {
            networking.hostName = "hazelweakly";
            age.sshKeyPaths =
              [ "${config.users.users.hazel.home}/.ssh/id_ed25519" ]
              ++ map (e: e.path) config.services.openssh.hostKeys;
          }
        )
        ./work.nix
        ./wireguard.nix
        nixos-hardware.nixosModules.common-gpu-nvidia
      ];
      hosts.hazelxps.modules = [
        ./machines/xps9350.nix
        ({ config, ... }: { networking.hostName = "hazelxps"; })
      ];

      sharedOverlays = overlays;
      overlay = overlays;

      hostDefaults.modules = [
        ./network.nix
        ./cachix.nix
        ./env.nix
        ./dyn-wp.nix
        ./common.nix
        ./proxy.nix
        ./users.nix

        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-ssd
        home-manager.nixosModules.home-manager
        (
          { pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hazel = import ./home.nix;
          }
        )
        (
          { pkgs, lib, ... }:
          let
            overlay-nix = pkgs.writeText "overlays.nix" ''
              (builtins.getFlake (builtins.toString /etc/nixos)).overlay
            '';
          in
          {
            environment.etc = lib.mapAttrs'
              (
                key: val: {
                  name = "channels/${key}";
                  value = {
                    source =
                      if key != "nixpkgs" then
                        val.outPath
                      else
                        pkgs.runCommandNoCC "nixpkgs" { } ''
                            cp -r ${nixpkgs} $out
                            chmod 700 $out
                            echo "${
                          nixpkgs.rev or (builtins.toString nixpkgs.lastModified)
                          }" > $out/.version-suffix
                        '';
                  };
                }
              )
              inputs;
            nix.nixPath =
              (
                lib.mapAttrsToList (name: _: "${name}=/etc/channels/${name}")
                  inputs
              ) ++ [
                "nixpkgs-overlays=${overlay-nix}"
                "nixos-config=/etc/nixos/compat/config.nix"
              ];
          }
        )
        { nix.generateRegistryFromInputs = true; }
      ];
    };
}
