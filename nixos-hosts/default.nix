{ self, inputs, ... }@args:
let
  mkNixosSystem = cfg: inputs.nixpkgs.lib.nixosSystem {
    inherit (cfg) system;
    pkgs = self.legacyPackages.${cfg.system};
    modules = cfg.modules ++ [
      ../modules/cachix.nix
      ../modules/environment.nix
      ({ pkgs, ... }: {
        fonts.fontDir.enable = true;
        fonts.fonts = [
          pkgs.open-sans
          pkgs.victor-mono
          (pkgs.nerdfonts.override { fonts = [ "VictorMono" ]; })
        ];
      })
      ../modules/fonts.nix
      ../modules/home-manager.nix
      ../modules/nix.nix
      ../modules/packages.nix
      ../modules/zsh.nix
      inputs.home-manager.nixosModules.home-manager
      inputs.bootspec-secureboot.nixosModules.bootspec-secureboot
    ];
    specialArgs = { inherit self; inherit (args) inputs; };
  };
in
builtins.mapAttrs
  (_: mkNixosSystem)
  (self.lib.rake ./.)
