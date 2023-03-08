{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    fonts.fontDir.enable = true;
    fonts.fonts = [
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-extra
      pkgs.open-sans
      pkgs.victor-mono
      (pkgs.iosevka.override {
        privateBuildPlan = ''
          [buildPlans.iosevka-custom]
          family = "Iosevka Custom"
          spacing = "quasi-proportional"
          serifs = "slab"
          no-cv-ss = false
          export-glyph-names = true

            [buildPlans.iosevka-custom.variants]
            inherits = "ss08"

              [buildPlans.iosevka-custom.variants.italic]
              capital-q = "open-swash"
              capital-z = "cursive-with-horizontal-crossbar"
              f = "tailed-crossbar-at-x-height"
              k = "symmetric-connected-serifed"
              q = "straight"
              z = "cursive-with-horizontal-crossbar"

            [buildPlans.iosevka-custom.ligations]
            inherits = "dlig"
        '';
        set = "custom";
      })
      (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
    ];
  }
  (lib.optionalAttrs systemProfile.isLinux {
    fonts.fontconfig.defaultFonts = {
      monospace = [ "VictorMono Nerd Font" ];
      sansSerif = [ "Open Sans" ];
      serif = [ "Noto Serif" ];
    };

    console.font = "latarcyrheb-sun32";
    console.keyMap = "us";
  })
  (lib.optionalAttrs systemProfile.isDarwin {
    system.activationScripts.fonts.text = lib.mkForce ''
      # Set up fonts.
      echo "configuring fonts..." >&2
      find -L "$systemConfig/Library/Fonts" -type f -print0 | while IFS= read -rd "" l; do
          font=''${l##*/}
          f=$(readlink -f "$l")
          if [ ! -e "/Library/Fonts/$font" ]; then
              echo "updating font $font..." >&2
              ln -fn -- "$f" /Library/Fonts 2>/dev/null || {
                echo "Could not create hard link. Nix is probably on another filesystem. Copying the font instead..." >&2
                rsync -az --inplace "$f" /Library/Fonts
              }
          fi
      done
    '';
  })
]
