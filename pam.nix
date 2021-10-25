{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.pam;
  inherit (builtins) concatStringsSep map;

  # Implementation Notes
  #
  # We don't use `environment.etc` because this would require that the user manually delete
  # `/etc/pam.d/sudo` which seems unwise given that applying the nix-darwin configuration requires
  # sudo. We also can't use `system.patchs` since it only runs once, and so won't patch in the
  # changes again after OS updates (which remove modifications to this file).
  #
  # As such, we resort to line addition/deletion in place using `sed`. We add a comment to the
  # added line that includes the name of the option, to make it easier to identify the line that
  # should be deleted when the option is disabled.
  mkScript = { enable, options ? [ ], files ? [ ], optionName, module, ... }:
    let
      opts = concatStringsSep " " options;
      script = file:
        if enable then ''
          if ! /usr/bin/grep '${module}' ${file} > /dev/null; then
            /usr/bin/sed -i "" '2i\
          auth       sufficient     ${module} ${opts} # nix-darwin: ${optionName}
            ' ${file}
          fi
        '' else ''
          if /usr/bin/grep '${option}' ${file} > /dev/null; then
            /usr/bin/sed -i "" '/${optionName}/d' ${file}
          fi
        '';
    in
    concatStringsSep "\n" (map script files);

  mkSudoTouchIdAuthScript = { enable, options ? [ ], ... }@args:
    let
      file = "/etc/pam.d/sudo";
      option = "security.pam.sudoTouchIdAuth";
      opts = builtins.concatStringsSep " " options;
      q = mkScript ({
        files = [ "/etc/pam.d/sudo" ];
        optionName = "security.pam.sudoTouchIdAuth";
        module = "pam_tid.so";
      } // args);
    in
    ''
      ${if enable then ''
        # Enable sudo Touch ID authentication, if not already enabled
        if ! /usr/bin/grep 'pam_tid.so' ${file} > /dev/null; then
          /usr/bin/sed -i "" '2i\
        auth       sufficient     pam_tid.so ${opts} # nix-darwin: ${option}
          ' ${file}
        fi
      '' else ''
        # Disable sudo Touch ID authentication, if added by nix-darwin
        if /usr/bin/grep '${option}' ${file} > /dev/null; then
          /usr/bin/sed -i "" '/${option}/d' ${file}
        fi
      ''}
    '';
  mku2fAuthScript = { enable, sudo ? { }, options ? [ ], ... } @ args:
    let
      files = [ "/etc/pam.d/screensaver" "/etc/pam.d/authorization" ] ++ optionals (sudo.enable or false) [ "/etc/pam.d/sudo" ];
      option = "security.pam.u2fAuth";
      opts = builtins.concatStringsSep " " options;
      script = file: ''
        ${if enable then ''
          # Enable u2f authentication, if not already enabled
          if ! /usr/bin/grep 'pam_u2f.so' ${file} > /dev/null; then
            /usr/bin/sed -i "" '2i\
          auth       sufficient     ${pkgs.pam_u2f}/lib/security/pam_u2f.so ${opts} # nix-darwin: ${option}
            ' ${file}
          fi
        '' else ''
          # Disable u2f authentication, if added by nix-darwin
          if /usr/bin/grep '${option}' ${file} > /dev/null; then
            /usr/bin/sed -i "" '/${option}/d' ${file}
          fi
        ''}
      '';
    in
    builtins.concatStringsSep "\n" (builtins.map script files);
in

{
  options = {
    security.pam.sudoTouchIdAuth = {
      enable = mkEnableOption ''
        Enable sudo authentication with Touch ID

        When enabled, this option adds the following line to /etc/pam.d/sudo:

            auth       sufficient     pam_tid.so

        (Note that macOS resets this file when doing a system update. As such, sudo
        authentication with Touch ID won't work after a system update until the nix-darwin
        configuration is reapplied.)
      '';
      options = mkOption {
        type = types.listOf types.str;
        description = "Options to pass into the module";
        default = [ ];
      };
    };
    security.pam.u2fAuth = {
      enable = mkEnableOption ''
        Enable authentication with Yubico u2f

        When enabled, this option adds the following line to /etc/pam.d/screensaver and /etc/pam.d/authorization:

        auth       sufficient     pam_u2f.so
        (Note that macOS resets this file when doing a system update. As such,
        authentication with Yubico won't work after a system update until the nix-darwin
        configuration is reapplied.)
      '';
      options = mkOption {
        type = types.listOf types.str;
        description = "Options to pass into the module";
        default = [ ];
      };
      sudo = mkOption {
        type = types.submodule {
          options.enable = mkEnableOption ''
            Enable sudo authentication with Yubico u2f

            When enabled, this option adds the following line to /etc/pam.d/sudo:

            auth       sufficient     pam_u2f.so
            (Note that macOS resets this file when doing a system update. As such,
            authentication with Yubico won't work after a system update until the nix-darwin
            configuration is reapplied.)
          '';
        };
        description = "configure how u2fAuth is used for sudo authorization";
        default = {
          enable = false;
        };
      };
    };
  };

  config = rec {
    environment.systemPackages = optionals (cfg.u2fAuth.enable) [ pkgs.pam_u2f ];
    system.activationScripts.pam.text = ''
      # PAM settings
      echo >&2 "setting up pam..."
      ${mku2fAuthScript cfg.u2fAuth}
      ${mkSudoTouchIdAuthScript cfg.sudoTouchIdAuth}
    '';

    # temp hack
    system.activationScripts.postActivation.text = system.activationScripts.pam.text;
  };
}
