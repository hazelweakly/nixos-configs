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
      ../home/homeage.nix
      ../modules/age.nix
      ../modules/alias-pkgs.nix
      ../modules/cachix.nix
      ../modules/defaults
      ../modules/encryption.nix
      ../modules/environment.nix
      ../modules/fonts.nix
      ../modules/hardware.nix
      ../modules/homebrew.nix
      ../modules/home-manager.nix
      ../modules/launchd
      ../modules/nix.nix
      ../modules/packages.nix
      ../modules/sudo-touch.nix
      ../modules/work.nix
      ../modules/zsh.nix
      ../modules/graphics.nix
      ../modules/input.nix
      ../modules/networking.nix
      ../modules/sound.nix
      ../modules/ssh.nix
      ../modules/users.nix
    ] ++ inputs.self.lib.optionals systemProfile.isLinux [
      inputs.agenix.nixosModules.default # nixos
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot # nixos only
      inputs.home-manager.nixosModules.home-manager # nixos only
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
