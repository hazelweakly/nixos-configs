{ self, inputs, system }:
let
  extensions = inputs.nixpkgs.lib.composeManyExtensions [
    (_: _: {
      legacyPackages = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnsupportedSystem = true;
        overlays = builtins.attrValues self.overlays;
      };
    })
  ];

  ourPkgs = pkgs: {
    packages = builtins.mapAttrs (_: v: pkgs.legacyPackages.callPackage v { }) (self.lib.rake ./.);
  };

in
inputs.nixpkgs.lib.fix (inputs.nixpkgs.lib.extends extensions ourPkgs)
