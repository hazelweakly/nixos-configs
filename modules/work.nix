{ pkgs, lib, systemProfile, ... }: lib.mkIf systemProfile.isWork (lib.mkMerge [
  {
    environment.systemPackages = with pkgs; [ fnm yarn nodejs ];
  }
  (lib.optionalAttrs systemProfile.isLinux {
    mercury = {
      internalCertificateAuthority.enable = true;
      mwbDevelopment.enable = true;
      nixCache.enable = true;
    };

    services.postgresql = {
      settings = {
        session_preload_libraries = "auto_explain";
        "auto_explain.log_min_duration" = 100;
        "auto_explain.log_analyze" = true;
        "auto_explain.log_buffers" = true;
        "auto_explain.log_format" = "json";
      };
    };
  })
  (lib.optionalAttrs systemProfile.isDarwin {
    homebrew.brews = [ "postgresql@14" "tailscale" "postgis" ];
  })
])
