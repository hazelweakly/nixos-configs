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
  gst = _: super: {
    gst_all_1 = let
      fn = n: s: {
        "${n}" = super.gst_all_1."${n}".overrideAttrs (o: rec {
          version = "1.18.1";
          src = builtins.fetchurl {
            url =
              "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
            sha256 = s;
          };
        });
      };

    in super.gst_all_1 // {
      gst-plugins-bad = super.gst_all_1.gst-plugins-bad.overrideAttrs (o: rec {
        version = "1.18.1";
        src = builtins.fetchurl {
          url =
            "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
          sha256 = "1cn18cbqyysrxnrk5bpxdzd5xcws9g2kmm5rbv00cx6rhn69g5f1";
        };
        patches = [ (builtins.elemAt o.patches 0) ];
      });
    } // (fn "gst-plugins-base"
      "0hf66sh8d4x2ksfnvaq2rqrrfq0vi0pv6wbh9i5jixrhvvbm99hv")
    // (fn "gst-devtools"
      "1pxhg8n5nl34baq6mb07i27b33gaw47zrv5yalyj6f12pnx148ki")
    // (fn "gst-editing-services"
      "09rr5a198p1r9wcbsjl01xg6idkfkgj5h9x7xxywarb5i7qv6g79")
    // (fn "gst-plugins-good"
      "0v329xi4qhlfh9aksfyviryqk9lclm4wj1lxrjnbdv4haldfj472")
    // (fn "gst-libav" "1n1fkkbxxsndblnbm0c2ziqp967hrz5gag6z36xbpvqk4sy1g9rr")
    // (fn "gst-rstp-server"
      "0m7p7sarvi6n9pz0rrl9k3gp3l5s42qs8z0165kyd6fiqdjjia0h")
    // (fn "gst-plugins-ugly"
      "09gpbykjchw3lb51ipxj53fy238gr9mg9jybcg5135pb56w6rk8q")
    // (fn "gstreamer-vaapi"
      "1sm6x2qa7ng78w0w8q4mjs7pbpbbk8qkfgzhdmbb8l0bh513q3a0");

    # gst-plugins-base = super.gst_all_1.gst-plugins-base.overrideAttrs
    #   (o: rec {
    #     version = "1.18.1";
    #     src = builtins.fetchurl {
    #       url =
    #         "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
    #       sha256 = "0hf66sh8d4x2ksfnvaq2rqrrfq0vi0pv6wbh9i5jixrhvvbm99hv";
    #     };
    #   });

    # gst-devtools = super.gst_all_1.gst-devtools.overrideAttrs (o: rec {
    #   version = "1.18.1";
    #   src = builtins.fetchurl {
    #     url =
    #       "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
    #     sha256 = "1pxhg8n5nl34baq6mb07i27b33gaw47zrv5yalyj6f12pnx148ki";
    #   };
    # });

    # gst-editing-services = super.gst_all_1.gst-editing-services.overrideAttrs
    #   (o: rec {
    #     version = "1.18.1";
    #     src = builtins.fetchurl {
    #       url =
    #         "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
    #       sha256 = "09rr5a198p1r9wcbsjl01xg6idkfkgj5h9x7xxywarb5i7qv6g79";
    #     };
    #   });

    # gst-plugins-good = super.gst_all_1.gst-plugins-good.overrideAttrs
    #   (o: rec {
    #     version = "1.18.1";
    #     src = builtins.fetchurl {
    #       url =
    #         "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
    #       sha256 = "0v329xi4qhlfh9aksfyviryqk9lclm4wj1lxrjnbdv4haldfj472";
    #     };
    #   });

    # gst-libav = super.gst_all_1.gst-libav.overrideAttrs (o: rec {
    #   version = "1.18.1";
    #   src = builtins.fetchurl {
    #     url =
    #       "${o.meta.homepage}/src/${o.pname}/${o.pname}-${version}.tar.xz";
    #     sha256 = "1n1fkkbxxsndblnbm0c2ziqp967hrz5gag6z36xbpvqk4sy1g9rr";
    #   };
    # });

  };

  # overlays = [ nts moz srcs search neuron machNix obelisk nvidia ];
  overlays = [ nts moz srcs search neuron machNix obelisk ];
in overlays
