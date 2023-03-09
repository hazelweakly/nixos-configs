{ self, inputs, ... }@args:
let
  userProfile = rec {
    name = "hazelweakly";
    home = "/Users/hazelweakly";
    flakeDir = home + "/src/personal/nixos-configs";
  };
  systemProfile = rec {
    isWork = false;
    isLinux = false;
    isDarwin = !isLinux;
  };
  mkDarwinSystem = cfg: inputs.nix-darwin.lib.darwinSystem {
    inherit (args) inputs;
    inherit (cfg) system;
    pkgs = self.legacyPackages.${cfg.system};
    modules = cfg.modules ++ [
      ../modules/work.nix
      ../modules/common.nix
      ../modules/age.nix
      ../modules/alias-pkgs.nix
      ../modules/cachix.nix
      ../modules/defaults
      ../modules/environment.nix
      ../modules/fonts.nix
      ../modules/home-manager.nix
      ../modules/homebrew.nix
      ../modules/launchd
      ../modules/nix.nix
      ../modules/packages.nix
      ../modules/sudo-touch.nix
      ../modules/zsh.nix
      ../home/homeage.nix
    ] ++ inputs.self.lib.optionals systemProfile.isLinux [
      inputs.home-manager.nixosModules.home-manager
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
      inputs.agenix.nixosModules.default
    ] ++ inputs.self.lib.optionals (systemProfile.isLinux && systemProfile.isWork) [
      inputs.mercury.nixosModule
      inputs.mercury.roles.aws.aws-mfa
      inputs.mercury.roles.certs
    ] ++ inputs.self.lib.optionals systemProfile.isDarwin [
      inputs.agenix.darwinModules.default
      inputs.home-manager.darwinModules.home-manager
    ];
    specialArgs = { inherit self userProfile systemProfile; };
  };
in
builtins.mapAttrs
  (_: mkDarwinSystem)
  (self.lib.rake ./.)
