{
  description = "Hazel's system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";

    bootspec-secureboot.url = "github:DeterminateSystems/bootspec-secureboot/main";
    bootspec-secureboot.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
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
    neovim-flake.inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";
    neovim-flake.inputs.flake-utils.follows = "flake-utils";

    firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    firefox-nightly.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, ... }: {
    overlays = import ./overlays { inherit self inputs; };

    lib = import ./lib.nix { inherit inputs; };

    nixosConfigurations = import ./nixos-hosts { inherit self inputs; };
    darwinConfigurations = import ./darwin-hosts { inherit self inputs; };
    homeManagerModules = self.lib.rake ./home;
    darwinModules = self.lib.rake ./modules;

  } // inputs.flake-utils.lib.eachDefaultSystem (system:
    let builtPkgs = import ./packages { inherit self inputs system; }; in {
      inherit (builtPkgs) legacyPackages packages;

      devShells.default = builtPkgs.legacyPackages.mkShell { };
    });
}
