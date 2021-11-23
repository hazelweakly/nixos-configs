{
  description = "Hazel's system configuration";
  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters = "https://nix-community.cachix.org https://hazel-nix-configs.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= hazel-nix-configs.cachix.org-1:AyBQRdv7dppOc1Kq9VyBb+8EuGbBZD8Hgsm9e2GnyCI=";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mkalias.url = "github:reckenrode/mkalias";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
    neovim-flake.inputs.flake-utils.follows = "flake-utils";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    mach-nix.url = "github:DavHau/mach-nix";
    mach-nix.inputs.flake-utils.follows = "flake-utils";

    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = inputs@{ self, ... }:
    let
      inherit (builtins) listToAttrs concatMap attrNames map mapAttrs;
      mapAttrs' = f: set: listToAttrs (map (attr: f attr set.${attr}) (attrNames set));

      filterAttrs = pred: set:
        listToAttrs (concatMap (name: let value = set.${name}; in if pred name value then [{ inherit name value; }] else [ ]) (attrNames set));

      flakes = filterAttrs (name: value: value ? outputs) inputs;
      flakesWithPkgs = filterAttrs (name: value: value.outputs ? legacyPackages || value.outputs ? packages) flakes;
    in

    {
      overlays =
        let
          inherit (builtins) head split readDir;
          prefix = s: head (split ".nix" s);
          impt = f: import (./overlays + "/${f}");
        in
        mapAttrs' (f: _: { name = prefix f; value = impt f; }) (readDir (./overlays));

      darwinConfigurations."Hazels-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
        system = "x86_64-darwin";
        inherit inputs;
        modules = [
          ./cachix.nix

          ({ lib, ... }: {
            nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") flakesWithPkgs;
            nix.registry = mapAttrs (name: v: { flake = v; }) flakes;
            environment.etc = mapAttrs'
              (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; })
              inputs;
          })
          {
            nixpkgs.overlays = [ inputs.rust-overlay.overlay (_:_: { inherit inputs; }) ] ++ (builtins.attrValues (self.overlays));
            imports = [ inputs.home-manager.darwinModules.home-manager ];
            nix.nixPath = [ "darwin=/etc/nix/inputs/nix-darwin" ]; # doesn't pick up nix-darwin
            environment.darwinConfig = "/etc/nix/inputs/self/compat/config.nix";
            environment.etc.hostname.text = ''
              Hazels-MacBook-Pro
            '';
          }
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hazelweakly = import ./home/users/hazelweakly.nix;
            home-manager.users.root = { pkgs, ... }: {
              home.homeDirectory = pkgs.lib.mkForce "/var/root";
              xdg.enable = true;
              programs.zsh.enable = true;
            };
          }
          ./pam.nix
          ./nix-darwin.nix
          ./work.nix
        ];
      };
      darwinPackages = self.darwinConfigurations."Hazels-MacBook-Pro".pkgs // {
        dev-shell = self.devShell.x86_64-darwin.inputDerivation;
      };
      devShell.x86_64-darwin = self.darwinPackages.mkShell {
        nativeBuildInputs = with self.darwinPackages; [ nixUnstable ];
      };
    };
}
