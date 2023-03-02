{ lib, systemProfile, ... }: lib.mkIf systemProfile.isDarwin {
  security.pam.sudoTouchIdAuth.enable = true;
}
