{ self, inputs, ... }@args:
let
  userProfile = rec {
    name = "hazel";
    home = "/home/hazel";
    flakeDir = home + "/src/personal/nixos-configs";
  };
  sysProfile = rec {
    isWork = true;
    isLinux = true;
    isDarwin = !isLinux;
  };
  mkNixosSystem = cfg:
    let
      specialArgs = { inherit self userProfile; systemProfile = sysProfile; inherit (args) inputs; };
      systemProfile = specialArgs.systemProfile;
    in
    inputs.nixpkgs.lib.nixosSystem {
      inherit (cfg) system;
      pkgs = self.legacyPackages.${cfg.system};
      modules = cfg.modules ++ [
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
      ] ++ inputs.self.lib.optionals (cfg.specialArgs.systemProfile.isLinux) [
        inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
        inputs.home-manager.nixosModules.home-manager
      ] ++ inputs.self.lib.optionals (cfg.specialArgs.systemProfile.isDarwin) [
        inputs.home-manager.darwinModules.home-manager
      ];
      inherit specialArgs;
    };
in
builtins.mapAttrs
  (_: mkNixosSystem)
  (self.lib.rake ./.)
