{ config, lib, ... }:

with lib;

let
  isFloat = x: isString x && builtins.match "^[+-]?([0-9]*[.])?[0-9]+$" x != null;

  float = mkOptionType {
    name = "float";
    description = "float";
    check = isFloat;
    merge = options.mergeOneOption;
  };

in
{
  options = {

    system.defaults.NSGlobalDomain.NSAutomaticTextCompletionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        A Boolean value that indicates whether the text field automatically completes text as the user types. The default is true.
      '';
    };

    # home-manager = mkOption {
    #   type = types.anything;
    # };

  };

}

