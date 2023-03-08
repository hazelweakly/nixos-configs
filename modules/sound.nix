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

    # do i even need literally any of this shit?
    # it was all to try and get the monitor working more better and i gave up on that
    services.pipewire = {
      config.pipewire = {
        "context.properties" = {
          "link.max-buffers" = 64;
          "default.clock.rate" = 192000;
          "default.clock.allowed-rates" = [ "44100" "48000" "96000" "192000" ];
        };
      };
      wireplumber.enable = false;
      media-session.enable = true;
      media-session.config.alsa-monitor.rules = [
        {
          matches = [
            { "device.name" = "~alsa_output.usb-Behringer_UV1-00.*"; }
            { "device.name" = "~alsa_input.usb-Behringer_UV1-00.*"; }
          ];
          actions = {
            "update-props" = {
              "node.nick" = "Behringer UV1";
              "node.description" = "Behringer UV1";
              "audio.format" = "S32_LE";
              "audio.rate" = 192000;
            };
          };
        }
      ];
    };
  })
]
