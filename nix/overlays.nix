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
  srcs = _: _: { inherit sources; };
  nvidia = _: super: {
    linuxPackages_5_8 = super.linuxPackages_5_8.extend (_: superLinux: {
      nvidia_x11 = superLinux.nvidia_x11 // {
        persistenced = superLinux.nvidia_x11.passthru.persistenced.overrideAttrs
          (o: {
            nativeBuildInputs = [ super.m4 super.pkg-config ];
            buildInputs = [ super.libtirpc ];
          });
      };
    });
  };
  tree-sitter = self: super: {
    tree-sitter = super.tree-sitter.overrideAttrs
      (oldAttrs: { postInstall = "PREFIX=$out make install"; });
  };
  nts = _: super: {
    gnomeExtensions = super.gnomeExtensions // {
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

  overlays = [ moz srcs search neuron machNix obelisk nvidia tree-sitter ];
in overlays
