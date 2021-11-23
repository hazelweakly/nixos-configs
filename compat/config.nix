let
  flake = import ./flake-compat.nix;
  hostname = with builtins; head (split "\n" (readFile /etc/hostname));
  system = builtins.currentSystem;
  cfg =
    if system == "x86_64-darwin" then flake.darwinConfigurations
    else if system == "x86_64-linux" then flake.nixosConfigurations else { };
  host = cfg.${hostname};

  # Add in all of the extra modules that are now included.
  # nix-darwin treats this as <darwin-config> and includes it as a module
  # so we can hack the extra module config checking by making this a "module" whose "options"
  # are the superset of all included modules.
in
{
  options = {
    inherit (host.options) home-manager;
    security.pam = host.options.security.pam;
    system.defaults.NSGlobalDomain.NSAutomaticTextCompletionEnabled = host.options.system.defaults.NSGlobalDomain.NSAutomaticTextCompletionEnabled;
  };
  config = host.config;
}
