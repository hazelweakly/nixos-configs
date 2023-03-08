{ pkgs, lib, config, systemProfile, ... }: lib.mkMerge [
  (lib.optionalAttrs systemProfile.isLinux {
    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    environment.systemPackages = with pkgs; [
      pavucontrol
    ];
  })
]
