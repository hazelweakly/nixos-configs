{ pkgs, lib, systemProfile, ... }: lib.mkMerge [
  # https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  (lib.optionalAttrs systemProfile.isLinux {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    environment.gnome.excludePackages = with pkgs; with pkgs.gnome3; [
      gnome-photos
      gnome-tour
      gnome-music
      gnome-terminal
      cheese
      epiphany
      geary
      gedit
      tali
      iagno
      hitori
      atomix
    ];
    programs.dconf.enable = true;
    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
    ];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    location.provider = "geoclue2";
    time.timeZone = "America/Los_Angeles";
  })
]
