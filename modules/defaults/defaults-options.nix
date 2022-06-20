{ lib, ... }: with lib; {
  options = {
    system.defaults.NSGlobalDomain.NSAutomaticTextCompletionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        A Boolean value that indicates whether the text field automatically completes text as the user types. The default is true.
      '';
    };
  };
}
