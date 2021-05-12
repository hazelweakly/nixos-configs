{
  description = "Hazel's system configuration";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
    neuron.url = "github:srid/neuron";
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
    matterhorn = {
      url = "github:matterhorn-chat/matterhorn";
      flake = false;
    };

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = inputs@{ self, nixpkgs, utils, home-manager, nixos-hardware
    , neovim-nightly-overlay, mach-nix, taskwarrior, neuron, obelisk
    , pop-os-shell, flake-utils, flake-firefox-nightly, rust-overlay, agenix
    , ... }:
    let
      moz' = self: super:
        let
          mapAttrs = super.stdenv.lib.mapAttrs;
          flip = super.stdenv.lib.flip;
        in {
          latest = super.latest // {
            rustChannels = flip mapAttrs super.latest.rustChannels (_: value:
              value // {
                rust = value.rust.override { extensions = [ "rust-src" ]; };
              });
          };
        };
      neuron-notes = _: _: {
        neuron-notes = neuron.defaultPackage.x86_64-linux;
      };
      obelisk = _: _: {
        obelisk = import inputs.obelisk { system = "x86_64-linux"; };
      };
      gnomeExts = _: super: {
        gnome3 = super.gnome3 // {
          geary = super.gnome3.geary.overrideAttrs (o: { doCheck = false; });
        };
        gnomeExtensions = super.gnomeExtensions // {
          pop-os = super.stdenv.mkDerivation rec {
            pname = "pop-os-shell";
            version = "master";
            src = pop-os-shell;
            nativeBuildInputs = [ super.glib super.nodePackages.typescript ];
            makeFlags = [
              "INSTALLBASE=$(out)/share/gnome-shell/extensions PLUGIN_BASE=$(out)/share/pop-shell/launcher SCRIPTS_BASE=$(out)/share/pop-shell/scripts"
            ];
          };
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
        in rec {
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
          firefox-nightly-bin-unwrapped = let
            policiesJSON = super.writeText "policy.json"
              (builtins.toJSON { inherit policies; });
          in flake-firefox-nightly.packages.x86_64-linux.firefox-nightly-bin.unwrapped.overrideAttrs
          (o: {
            installPhase = (o.installPhase or "") + ''
              ln -sf ${self.p11-kit}/lib/pkcs11/p11-kit-trust.so $out/lib/${n}/libnssckbi.so
              ln -sf ${policiesJSON} $out/lib/${n}/distribution/policies.json
            '';
          });
        };
      task = _: super: {
        taskwarrior = super.taskwarrior.overrideAttrs (o: rec {
          version = "2.6.0";
          src = inputs.taskwarrior;
          postInstall = ''
            mkdir -p "$out/share/bash-completion/completions"
            ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
            mkdir -p "$out/share/fish/vendor_completions.d"
            ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/"
            mkdir -p "$out/share/zsh/site-functions"
          '';
        });
      };
      overlays = [
        neuron-notes
        neovim-nightly-overlay.overlay
        (_: _: {
          mach-nix = let
            mn = mach-nix.packages.x86_64-linux.mach-nix.overrideAttrs
              (o: { name = builtins.elemAt (builtins.split "\n" o.name) 0; });
          in mach-nix.packages.x86_64-linux.mach-nix // {
            mach-nix = mn;
          } // mach-nix.lib.x86_64-linux;
        })
        moz'
        gnomeExts
        intel
        ffox
        rust-overlay.overlay
        task
        obelisk
      ];
    in utils.lib.systemFlake {
      inherit self inputs;
      channels.nixpkgs.input = nixpkgs;
      channelsConfig.allowUnfree = true;

      defaultApp.x86_64-linux = let
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        drv = pkgs.writeScriptBin "nxr" ''
          #!${pkgs.runtimeShell}
          exec ${pkgs.nixUnstable}/bin/nix repl ${inputs.utils.lib.repl}
        '';
      in flake-utils.lib.mkApp { inherit drv; };

      hosts.hazelweakly.modules = [
        ./machines/nvidia.nix
        ./machines/precision7740.nix
        agenix.nixosModules.age
        ({ config, ... }: {
          networking.hostName = "hazelweakly";
          age.sshKeyPaths =
            [ "${config.users.users.hazel.home}/.ssh/id_ed25519" ]
            ++ map (e: e.path) config.services.openssh.hostKeys;
        })
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
        ({ pkgs, ... }: {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hazel = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        })
        ({ pkgs, lib, ... }:
          let
            overlay-nix = pkgs.writeText "overlays.nix" ''
              (builtins.getFlake (builtins.toString /etc/nixos)).overlay
            '';
          in {
            environment.etc = lib.mapAttrs' (key: val: {
              name = "channels/${key}";
              value = {
                source = if key != "nixpkgs" then
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
            }) inputs;
            nix.nixPath =
              (lib.mapAttrsToList (name: _: "${name}=/etc/channels/${name}")
                inputs) ++ [
                  "nixpkgs-overlays=${overlay-nix}"
                  "nixos-config=/etc/nixos/compat/config.nix"
                ];
          })
        utils.nixosModules.saneFlakeDefaults
      ];
    };
}
