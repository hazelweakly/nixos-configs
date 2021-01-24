{ sources ? import ./sources.nix }:
let
  machNix = _: _: { mach-nix = import sources.mach-nix { }; };
  moz = import sources.nixpkgs-mozilla;
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
  neuron = _: _: { neuron = import sources.neuron { }; };
  obelisk = _: _: { obelisk = import sources.obelisk { }; };
  search = _: super: {
    haskellPackages = super.recurseIntoAttrs super.haskellPackages;
    nodePackages = super.recurseIntoAttrs super.nodePackages;
  };
  gnomeExts = _: super: {
    gnomeExtensions = super.gnomeExtensions // {
      pop-os = super.stdenv.mkDerivation rec {
        pname = "pop-os-shell";
        version = "1.1.0";
        src = super.fetchFromGitHub {
          owner = "pop-os";
          repo = "shell";
          rev = version;
          sha256 = "sha256-KOp/0R7P/iH52njr7JPDKd4fAoN88d/pfou2gWy5QPk=";
        };
        nativeBuildInputs = [ super.glib super.nodePackages.typescript ];
        makeFlags = [
          "INSTALLBASE=$(out)/share/gnome-shell/extensions PLUGIN_BASE=$(out)/share/pop-shell/launcher"
        ];
      };

      night-theme-switcher =
        super.gnomeExtensions.night-theme-switcher.overrideAttrs (o: rec {
          version = "40";
          src = super.fetchFromGitLab {
            owner = "rmnvgr";
            repo = "nightthemeswitcher-gnome-shell-extension";
            rev = "v${version}";
            sha256 = "0z11y18bgdc0y41hrrzzgi4lagm2cg06x12jgdnary1ycng7xja0";
          };
        });
    };
  };
  dns = _: super: {
    coredns = super.buildGoModule rec {
      pname = "coredns";
      version = "master";
      src = super.fetchFromGitHub {
        owner = "coredns";
        repo = "coredns";
        rev = "${version}";
        sha256 = "1rs1hmx3jbhybmv3488hrxwr9jjddv5lw84d5vdf2zvc8208wxg5";
      };
      vendorSha256 = "1rn46z9p6fdi1y42wkqxgq2zngg098isdhbbl9wplbrr72zgki0m";
      doCheck = false;
    };
  };
  intel = _: super: {
    vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
  };
  ffox = self: super: {
    firefox-devedition-bin-unwrapped = let
      j = super.writeText "policy.json" (builtins.toJSON {
        policies = {
          Certificates = { Install = [ "/etc/ssl/certs/ca-bundle.crt" ]; };
          DisableAppUpdate = true;
        };
      });
    in super.latest.firefox-devedition-bin.unwrapped.overrideAttrs (o: {
      installPhase = o.installPhase + ''
        ln -sf ${j} "$out/lib/firefox-bin-${self.firefox-devedition-bin.version}/distribution/policies.json"
      '';
    });
    ffox-devz = self.firefox-devedition-bin;
    firefox-devedition-bin =
      super.wrapFirefox (self.firefox-devedition-bin-unwrapped) {
        browserName = "firefox";
        pname = "firefox-bin";
        desktopName = "Firefox";
        firefoxLibName = "firefox-bin-${self.firefox-devedition-bin.version}";
      };
  };
  task = _: super: {
    taskwarrior = super.taskwarrior.overrideAttrs (o: rec {
      version = "2.6.0";
      # src = sources.taskwarrior.outPath;

      src = super.fetchFromGitHub {
        inherit (sources.taskwarrior) owner repo rev;
        sha256 = "11vcn6ivpqwr2hb8nyq8nai7khk01042qkr353s2sg1lcq969j88";
        fetchSubmodules = true;
      };

      postInstall = ''
        mkdir -p "$out/share/bash-completion/completions"
        ln -s "../../doc/task/scripts/bash/task.sh" "$out/share/bash-completion/completions/task.bash"
        mkdir -p "$out/share/fish/vendor_completions.d"
        ln -s "../../../share/doc/task/scripts/fish/task.fish" "$out/share/fish/vendor_completions.d/"
        mkdir -p "$out/share/zsh/site-functions"
      '';
    });
  };
  srcs = _: _: { inherit sources; };
  overlays = [
    gnomeExts
    moz
    moz'
    srcs
    search
    neuron
    machNix
    obelisk
    dns
    intel
    ffox
    task
  ];
in overlays
