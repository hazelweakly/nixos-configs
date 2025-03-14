{ lib, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isDarwin {
    security.pam.services.sudo_local.touchIdAuth = true;
  })
]
