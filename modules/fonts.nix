{ pkgs, lib, ... }: {
  fonts.fontDir.enable = true;
  fonts.fonts = [
    pkgs.open-sans
    pkgs.victor-mono
    (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
  ];
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
}
