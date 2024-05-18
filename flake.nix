{
  description = "Hazel's system configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "nix-darwin";

    # https://github.com/NixOS/rfcs/pull/125
    # look at https://github.com/nix-community/lanzaboote
    bootspec-secureboot.url = "github:DeterminateSystems/bootspec-secureboot/main";
    bootspec-secureboot.inputs.nixpkgs.follows = "nixpkgs";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mkalias.url = "github:reckenrode/mkalias";
    mkalias.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.flake-utils.follows = "flake-utils";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    neovim-flake.url = "github:neovim/neovim?dir=contrib";
    neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
    neovim-flake.inputs.flake-utils.follows = "flake-utils";

    nil.url = "github:oxalica/nil";
    nil.inputs.nixpkgs.follows = "nixpkgs";
    nil.inputs.flake-utils.follows = "flake-utils";
    nil.inputs.rust-overlay.follows = "rust-overlay";

    firefox-nightly.url = "github:colemickens/flake-firefox-nightly";
    firefox-nightly.inputs.nixpkgs.follows = "nixpkgs";

    otel-cli.url = "github:equinix-labs/otel-cli";
    otel-cli.flake = false;

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nvim-treesitter.url = "github:nvim-treesitter/nvim-treesitter";
    nvim-treesitter.flake = false;

    kitty.url = "github:kovidgoyal/kitty";
    kitty.flake = false;

    lix = {
      url = "git+ssh://git@git.lix.systems/lix-project/lix";
      flake = false;
    };

    lix-module = {
      url = "git+ssh://git@git.lix.systems/lix-project/nixos-module";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.lix.follows = "lix";
    };
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

      devShells.default = builtPkgs.legacyPackages.mkShell {
        nativeBuildInputs = [ inputs.agenix.packages.${system}.agenix builtPkgs.legacyPackages.stylua ];
      };
    });
}
