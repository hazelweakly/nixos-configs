{ self, inputs, ... }@args:
let
  userProfile = rec {
    name = "hazel";
    home = "/home/hazel";
    flakeDir = home + "/src/personal/nixos-configs";
  };
  systemProfile = rec {
    isWork = true;
    isLinux = true;
    isDarwin = !isLinux;
  };
  mkNixosSystem = cfg: inputs.nixpkgs.lib.nixosSystem {
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
      ../modules/pam.nix
      ../modules/sudo-touch.nix
      ../modules/packages.nix
      ../modules/zsh.nix
      ../home/homeage.nix
    ] ++ inputs.self.lib.optionals systemProfile.isLinux [
      inputs.home-manager.nixosModules.home-manager # nixos only
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot # nixos only
      inputs.agenix.nixosModules.default # nixos
    ] ++ inputs.self.lib.optionals (systemProfile.isLinux && systemProfile.isWork) [
      inputs.mercury.nixosModule # nixos + work only
      inputs.mercury.roles.aws.aws-mfa # nixos  + work only
      inputs.mercury.roles.certs # nixos + work only
    ] ++ inputs.self.lib.optionals systemProfile.isDarwin [
      inputs.agenix.darwinModules.default # macos only
      inputs.home-manager.darwinModules.home-manager # macos only
    ];
    specialArgs = { inherit self userProfile systemProfile; inherit (args) inputs; };
  };
in
builtins.mapAttrs
  (_: mkNixosSystem)
  (self.lib.rake ./.)
