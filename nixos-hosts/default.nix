{ self, inputs, ... }@args:
let
  mkNixosSystem = cfg: inputs.nixpkgs.lib.nixosSystem {
    inherit (cfg) system;
    pkgs = self.legacyPackages.${cfg.system};
    modules = cfg.modules ++ [
      ../modules/cachix.nix
      ../modules/environment.nix
      ../modules/fonts.nix
      ../modules/linux-fonts.nix
      ../modules/home-manager.nix
      ../modules/nix.nix
      ../modules/packages.nix
      ../modules/zsh.nix
      ../modules/linux-zsh.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
      inputs.mercury.nixosModule
      inputs.mercury.roles.aws.aws-mfa
      inputs.mercury.roles.certs
    ];
    specialArgs = { inherit self; inherit (args) inputs; };
  };
in
builtins.mapAttrs
  (_: mkNixosSystem)
  (self.lib.rake ./.)
