{ self, inputs, ... }:
let
  inherit (inputs.digga.lib) allProfilesTest;

  common_modules = [
    ../network.nix
    ../cachix.nix
    ../env.nix
    ../dyn-wp.nix
    ../common.nix
    ../proxy.nix
    ../users.nix

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.home-manager.nixosModules.home-manager
    inputs.agenix.nixosModules.age

    ({ pkgs, ... }: {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      # home-manager.users.hazel = import ../home.nix;
      home-manager.home.homeDirectory = "/home/hazel";
    })

    ({ pkgs, lib, ... }:
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
                        cp -r ${inputs.nixos} $out
                        chmod 700 $out
                        echo "${
                          inputs.nixos.rev or (builtins.toString inputs.nixos.lastModified)
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
      })
  ];
in
{
  hostDefaults.channelName = "nixos"; # needs to be here. dum.
  hosts = {
    # hazelweakly.modules = [
    #   ../machines/nvidia.nix
    #   ../machines/precision7740.nix
    #   ../hazelweakly.nix
    #   ../work.nix
    #   ../wireguard.nix
    #   inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    # ] ++ common_modules;
    # hazelweakly.tests = [ allProfilesTest ];

    # hazelxps.modules = [ ../machines/xps9350.nix ../hazelxps.nix ] ++ common_modules;
    # hazelxps.tests = [ allProfilesTest ];

    Hazels-MacBook-Pro = {
      system = "x86_64-darwin";
      # builder = inputs.nix-darwin.lib.darwinSystem;
      # output = "darwinConfigurations";
      modules = [
        { config._module.check = false; }
        ../cachix.nix
        inputs.home-manager.darwinModules.home-manager
        {
          nixpkgs.overlays = builtins.attrValues (self.overlays) ++ [ inputs.flake-utils-plus.overlay ];
          nix.generateRegistryFromInputs = true;
          nix.generateNixPathFromInputs = true;
          nix.linkInputs = true;
          nix.nixPath = [ "darwin=/etc/nix/inputs/darwin" ]; # generateNixPathFromInputs doesn't pick up nix-darwin
          environment.darwinConfig = "/etc/nix/inputs/self/compat/config.nix";
          environment.etc.hostname.text = ''
            Hazels-MacBook-Pro
          '';
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.hazelweakly = import ../home/users/hazelweakly.nix;
          home-manager.users.root = { pkgs, ... }: {
            home.homeDirectory = pkgs.lib.mkForce "/var/root";
            xdg.enable = true;
            programs.zsh.enable = true;
          };
        }
        ../pam.nix
        ../nix-darwin.nix
        ../work.nix
      ];
      tests = [ allProfilesTest ];
    };
  };
}
