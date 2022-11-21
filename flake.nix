{
  description = "Hazel's system configuration";
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
  };

  outputs = inputs@{ self, ... }: {
    overlays = import ./overlays { inherit self inputs; };

    lib = import ./lib.nix { inherit inputs; };

    darwinConfigurations = import ./hosts { inherit self inputs; };
    homeManagerModules = self.lib.rake ./home;
    darwinModules = self.lib.rake ./modules;

  } // inputs.flake-utils.lib.eachDefaultSystem (system:
    let builtPkgs = import ./packages { inherit self inputs system; }; in {
      inherit (builtPkgs) legacyPackages packages;

      devShells.default = builtPkgs.legacyPackages.mkShell { };
    });
}
