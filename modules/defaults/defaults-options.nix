{ lib, ... }: with lib; {
  options = {
    system.defaults.NSGlobalDomain.NSAutomaticTextCompletionEnabled = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = ''
        A Boolean value that indicates whether the text field automatically completes text as the user types. The default is true.
      '';
    };

    system.defaults.dock.wvous-br-modifier = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      description = ''
        Hot corner modifier for top right corner. Valid values include:

        <itemizedlist>
        <listitem><para><literal>0</literal>: No Shortcut</para></listitem>
        </itemizedlist>
      '';
    };

    system.defaults.dock.wvous-tl-modifier = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      description = ''
        Hot corner modifier for top right corner. Valid values include:

        <itemizedlist>
        <listitem><para><literal>0</literal>: No Shortcut</para></listitem>
        </itemizedlist>
      '';
    };
  };
}
