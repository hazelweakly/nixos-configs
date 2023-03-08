{ pkgs, lib, config, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    services.xserver.layout = "us";
    services.xserver.libinput.enable = true;
    services.xserver.libinput.touchpad.middleEmulation = true;
    services.xserver.libinput.touchpad.tapping = true;

    services.xserver.xkbVariant = "altgr-intl";
    services.xserver.autoRepeatDelay = 160;
    services.xserver.autoRepeatInterval = 30;

    services.xserver.libinput.touchpad.naturalScrolling = true;
    services.xserver.libinput.touchpad.disableWhileTyping = true;
    services.xserver.libinput.touchpad.accelSpeed = "0.5";
    services.xserver.libinput.touchpad.calibrationMatrix = ".5 0 0 0 .5 0 0 0 1";
  })
]
