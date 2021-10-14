{
  description = "Hazel's system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs-digga.url = "github:nixos/nixpkgs/f048b1401f8246c4a8841d15190ebe7c8f15941a";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixpkgs-digga";
    digga.inputs.nixlib.follows = "nixpkgs-digga";
    digga.inputs.flake-utils-plus.follows = "flake-utils-plus";

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
    flake-utils-plus = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
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
    neuron = {
      url = "github:srid/neuron";
      inputs.flake-utils.follows = "flake-utils";
      inputs.flake-compat.follows = "flake-compat";
    };
    taskwarrior = {
      url = "https://github.com/GothenburgBitFactory/taskwarrior.git";
      type = "git";
      ref = "2.6.0";
      submodules = true;
      flake = false;
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
    , digga
    , nix-darwin
    , ...
    }:

    digga.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;
      channels.nixpkgs.overlays = [ agenix.overlay rust-overlay.overlay (_:_: { inherit inputs; }) ];
      channels.nixpkgs.imports = [ (digga.lib.importOverlays ./overlays) ];

      nixos = ./hosts;
      home = ./home;

      hostDefaults.builder = inputs.nix-darwin.lib.darwinSystem;
      hostDefaults.output = "darwinConfigurations";
      hostDefaults.channelName = "nixpkgs";
      hostDefaults.modules = [{ config.lib = self.lib; }]; # why the fuck does this even work?

      darwinPackages = self.pkgs."x86_64-darwin".nixpkgs;

      homeConfigurations = digga.lib.mkHomeConfigurations ((self.nixosConfigurations or {}) // (inputs.nixpkgs.lib.recursiveUpdate (self.darwinConfigurations or {}) {Hazels-MacBook-Pro.config.networking.domain = null;}));

    };
}
