{ inputs }:
let
  # Layers multiple libraries on top of each other, merging them together into
  # a single large attribute set for convenience.
  extensions = inputs.nixpkgs.lib.composeManyExtensions [
    (_: _: inputs.nixpkgs.lib)
    (_: _: inputs.flake-utils.lib)
  ];

  ourLib = self: with builtins; {
    removeSuffix = suffix: str:
      let end = if match ".*(${suffix})$" str == null then 0 else stringLength suffix;
      in substring 0 ((stringLength str) - end) str;
    inputsWithPkgs = inputs: self.filterAttrs (_: i: any (a: (i.outputs or { }) ? "${a}") [ "packages" "legacyPackages" ]) inputs;
    inputsWithOutputs = inputs: self.filterAttrs (_: v: v ? outputs) inputs;
    rake = dir: self.mapAttrs' (k: v: { name = self.removeSuffix ".nix" k; value = import (dir + "/${k}"); }) (removeAttrs (readDir dir) [ "default.nix" ]);
  };

in
(inputs.nixpkgs.lib.makeExtensible ourLib).extend extensions
