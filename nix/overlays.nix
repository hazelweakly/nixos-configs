{ sources ? import ./sources.nix }:
let
  machNix = _: _: { mach-nix = import sources.mach-nix { }; };
  moz = import sources.nixpkgs-mozilla;
  neuron = _: _: { neuron = import sources.neuron { }; };
  obelisk = _: _: { obelisk = import sources.obelisk { }; };
  search = _: super: {
    haskellPackages = super.recurseIntoAttrs super.haskellPackages;
    nodePackages = super.recurseIntoAttrs super.nodePackages;
  };
  gnomeExtensions = _: super: {
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

  srcs = _: _: { inherit sources; };
  overlays = [ gnomeExtensions moz srcs search neuron machNix obelisk ];
in overlays
