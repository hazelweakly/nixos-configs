{ config, pkgs, lib, inputs, self, systemProfile, userProfile, ... }: lib.mkMerge [
  {
    nix.settings.experimental-features = [ "flakes" "nix-command" ];
    nix.settings.keep-outputs = true;
    nix.settings.keep-derivations = true;
    nix.settings.auto-optimise-store = !pkgs.stdenv.isDarwin;
    nix.settings.trusted-users = [ "root" userProfile.name ];
    nix.settings.plugin-files = lib.optionals pkgs.stdenv.isLinux [ "${pkgs.nix-doc}/lib/libnix_doc_plugin.so" ]
      ++ lib.optionals pkgs.stdenv.isDarwin [ "${pkgs.nix-doc}/lib/libnix_doc_plugin.dylib" ];

    environment.systemPackages = [ pkgs.nix-doc ];

    nix.nixPath = lib.mapAttrsToList (n: _: "${n}=/etc/nix/inputs/${n}") (self.lib.inputsWithPkgs inputs)
      ++ lib.optionals pkgs.stdenv.isDarwin [ "darwin-config=/etc/nix/inputs/self" ]
      ++ lib.optionals pkgs.stdenv.isLinux [ "nixos-config=/etc/nix/inputs/self" ];
    nix.registry = builtins.mapAttrs (_: v: { flake = v; }) (self.lib.inputsWithOutputs inputs);
    environment.etc = lib.mapAttrs' (n: v: self.lib.nameValuePair "nix/inputs/${n}" { source = v.outPath; }) inputs;
  }
  (lib.optionalAttrs systemProfile.isLinux {
    system.stateVersion = "23.05";
  })
  (lib.optionalAttrs systemProfile.isDarwin {
    services.nix-daemon.enable = true;
    system.stateVersion = 4;
  })
]
