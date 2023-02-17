{ self, inputs, ... }@args:
let
  mkDarwinSystem = cfg: inputs.nix-darwin.lib.darwinSystem {
    inherit (args) inputs;
    inherit (cfg) system;
    pkgs = self.legacyPackages.${cfg.system};
    modules = cfg.modules ++ [
      ../modules/age.nix
      ../modules/alias-pkgs.nix
      ../modules/cachix.nix
      ../modules/defaults
      ../modules/environment.nix
      ../modules/fonts.nix
      ../modules/home-manager.nix
      ../modules/homebrew.nix
      ../modules/launchd
      ../modules/macos-fonts.nix
      ../modules/macos-nix.nix
      ../modules/nix.nix
      ../modules/packages.nix
      ../modules/pam.nix
      ../modules/sudo-touch.nix
      ../modules/zsh.nix
      inputs.home-manager.darwinModules.home-manager
      inputs.agenix.darwinModules.default
    ];
    specialArgs = { inherit self; };
  };
in
builtins.mapAttrs
  (_: mkDarwinSystem)
  (self.lib.rake ./.)
