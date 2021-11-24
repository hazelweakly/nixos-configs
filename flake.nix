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
    mkalias.inputs.nixpkgs.follows = "nixpkgs";
    mkalias.inputs.flake-utils.follows = "flake-utils";
    mkalias.inputs.rust-overlay.follows = "rust-overlay";

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

  outputs = inputs@{ self, ... }: {
    overlays = import ./overlays;

    darwinConfigurations."Hazels-MacBook-Pro" = inputs.nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      inherit inputs;
      modules = import ./modules/hosts/Hazels-MacBook-Pro.nix { inherit self inputs; };
      specialArgs = { inherit self; };
    };
    darwinPackages = self.darwinConfigurations."Hazels-MacBook-Pro".pkgs // {
      dev-shell = self.devShell.x86_64-darwin.inputDerivation;
    };
    devShell.x86_64-darwin = self.darwinPackages.mkShell {
      nativeBuildInputs = with self.darwinPackages; [ nixUnstable ];
    };
  };
}
