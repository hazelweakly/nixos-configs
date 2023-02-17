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
      ../modules/cachix.nix
      ../modules/environment.nix
      ../modules/fonts.nix
      ../modules/home-manager.nix
      ../modules/nix.nix
      ../modules/packages.nix
      ../modules/zsh.nix
      inputs.home-manager.nixosModules.home-manager
      ../home/homeage.nix
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
      inputs.mercury.nixosModule
      inputs.mercury.roles.aws.aws-mfa
      inputs.mercury.roles.certs
      inputs.agenix.nixosModules.default
    ];
    specialArgs = { inherit self userProfile systemProfile; inherit (args) inputs; };
  };
in
builtins.mapAttrs
  (_: mkNixosSystem)
  (self.lib.rake ./.)
