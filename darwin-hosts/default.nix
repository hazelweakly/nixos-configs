{ self, inputs, ... }@args:
let
  userProfile = rec {
    name = "hazel";
    home = "/Users/${name}";
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
      ../home/homeage.nix
      ../modules/age.nix
      ../modules/alias-pkgs.nix
      ../modules/cachix.nix
      ../modules/defaults
      ../modules/docker.nix
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
      inputs.home-manager.nixosModules.home-manager
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
      inputs.agenix.nixosModules.default
    ] ++ inputs.self.lib.optionals systemProfile.isDarwin [
      inputs.agenix.darwinModules.default
      inputs.home-manager.darwinModules.home-manager
    ];
    specialArgs = { inherit self userProfile systemProfile; } // (cfg.specialArgs or { });
  };
in
builtins.mapAttrs
  (_: mkDarwinSystem)
  (self.lib.rake ./.)
