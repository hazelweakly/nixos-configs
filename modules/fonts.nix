{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  {
    fonts.fontDir.enable = true;
    fonts.fonts = [
      pkgs.noto-fonts
      pkgs.noto-fonts-emoji
      pkgs.noto-fonts-extra
      pkgs.zilla-slab
      pkgs.open-sans
      pkgs.victor-mono
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
