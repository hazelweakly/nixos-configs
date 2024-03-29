{ self, inputs, system }:
let
  extensions = inputs.nixpkgs.lib.composeManyExtensions [
    (_: _: {
      legacyPackages = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowUnsupportedSystem = true;
        config.allowBroken = true;
        overlays = builtins.attrValues self.overlays;
        config.permittedInsecurePackages = [
          # "xpdf-4.04"
        ];
      };
    })
  ];

  ourPkgs = pkgs: {
    packages = builtins.mapAttrs (_: v: pkgs.legacyPackages.callPackage v { }) (self.lib.rake ./.);
  };

in
inputs.nixpkgs.lib.fix (inputs.nixpkgs.lib.extends extensions ourPkgs)
