{
  description = "Hazel's system configuration";
  nixConfig.extra-experimental-features = "nix-command flakes ca-references";
  nixConfig.extra-substituters = "https://nix-community.cachix.org https://hazel-nix-configs.cachix.org";
  nixConfig.extra-trusted-public-keys = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= hazel-nix-configs.cachix.org-1:AyBQRdv7dppOc1Kq9VyBb+8EuGbBZD8Hgsm9e2GnyCI=";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    darwin.follows = "nix-darwin";
    nix-darwin.url = "github:lnl7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-firefox-nightly = {
      url = "github:colemickens/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dynamic-wallpaper = {
      url = "github:adi1090x/dynamic-wallpaper";
      flake = false;
    };
    pop-os-shell = {
      url = "github:pop-os/shell";
      flake = false;
    };
    matterhorn = {
      url = "github:matterhorn-chat/matterhorn";
      flake = false;
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    notify-send = {
      type = "github";
      owner = "M3TIOR";
      repo = "notify-send.sh";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , rust-overlay
    , agenix
    , nix-darwin
    , ...
    }:
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
          { config._module.check = false; }
          ./cachix.nix
          inputs.home-manager.darwinModules.home-manager
          ({ lib, ... }: {
            nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") flakesWithPkgs;
            nix.registry = mapAttrs (name: v: { flake = v; }) flakes;
            environment.etc = mapAttrs'
              (name: value: { name = "nix/inputs/${name}"; value = { source = value.outPath; }; })
              inputs;
          })
          {
            nixpkgs.overlays = [ agenix.overlay rust-overlay.overlay (_:_: { inherit inputs; }) ] ++ (builtins.attrValues (self.overlays));
            nix.nixPath = [ "darwin=/etc/nix/inputs/darwin" ]; # generateNixPathFromInputs doesn't pick up nix-darwin
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
