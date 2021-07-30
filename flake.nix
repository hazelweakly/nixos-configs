{
  description = "Hazel's system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    digga.url = "github:divnix/digga";
    digga.inputs.nixpkgs.follows = "nixpkgs";
    digga.inputs.nixlib.follows = "nixpkgs";

    # needed for digga I guess?
    naersk.url = "github:nmattia/naersk";
    naersk.inputs.nixpkgs.follows = "nixpkgs";

    deploy.follows = "digga/deploy";
    flake-utils.url = "github:numtide/flake-utils";

    # anti corruption bullshit
    nixos.follows = "nixpkgs";
    nixlib.follows = "digga/nixlib";
    blank.follows = "digga/blank";
    flake-utils-plus.follows = "utils";
    # end bullshit

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
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
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
    pop-os-shell-shortcuts = {
      url = "github:pop-os/shell-shortcuts";
      flake = false;
    };
    night-theme-switcher = {
      url = "gitlab:/rmnvgr/nightthemeswitcher-gnome-shell-extension/v50";
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
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , home-manager
    , nixos-hardware
    , rust-overlay
    , agenix
    , digga
    , ...
    }:
    digga.lib.mkFlake {
      inherit self inputs;
      channelsConfig.allowUnfree = true;
      channels.nixpkgs.input = nixpkgs;
      channels.nixpkgs.overlays = [ agenix.overlay rust-overlay.overlay (_:_: { inherit inputs; }) ];
      channels.nixpkgs.imports = [ (digga.lib.importOverlays ./overlays) ];

      nixos.hosts.hazelweakly.modules = [
        ./machines/nvidia.nix
        ./machines/precision7740.nix
        ./hazelweakly.nix
        ./work.nix
        ./wireguard.nix
        nixos-hardware.nixosModules.common-gpu-nvidia
      ];

      nixos.hosts.hazelxps.modules = [
        ./machines/xps9350.nix
        ./hazelxps.nix
      ];

      nixos.hostDefaults.channelName = "nixpkgs";
      nixos.hostDefaults.externalModules = [
        nixos-hardware.nixosModules.common-cpu-intel
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-ssd
        home-manager.nixosModules.home-manager
        agenix.nixosModules.age

        (
          { pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hazel = import ./home.nix;
          }
        )
        # { nix.generateRegistryFromInputs = true; }
        (
          { pkgs, lib, ... }:
          let
            overlay-nix = pkgs.writeText "overlays.nix" ''
              builtins.attrValues (builtins.getFlake (builtins.toString /etc/nixos)).overlays
            '';
          in
          {
            environment.etc = lib.mapAttrs'
              (
                key: val: {
                  name = "channels/${key}";
                  value = {
                    source =
                      if key != "nixpkgs" then
                        val.outPath
                      else
                        pkgs.runCommandNoCC "nixpkgs" { } ''
                            cp -r ${nixpkgs} $out
                            chmod 700 $out
                            echo "${
                          nixpkgs.rev or (builtins.toString nixpkgs.lastModified)
                          }" > $out/.version-suffix
                        '';
                  };
                }
              )
              inputs;
            nix.nixPath =
              (
                lib.mapAttrsToList (name: _: "${name}=/etc/channels/${name}")
                  inputs
              ) ++ [
                "nixpkgs-overlays=${overlay-nix}"
                "nixos-config=/etc/channels/self/compat/config.nix"
              ];
          }
        )
      ];

      nixos.hostDefaults.modules = [
        ./network.nix
        ./cachix.nix
        ./env.nix
        ./dyn-wp.nix
        ./common.nix
        ./proxy.nix
        ./users.nix
      ];
    };
}
