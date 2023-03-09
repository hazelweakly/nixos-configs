{ lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    security.pam.sudoTouchIdAuth.enable = true;
  })
]
