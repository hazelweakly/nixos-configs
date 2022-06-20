{ self, inputs, ... }@args:
let
  mkDarwinSystem = cfg: inputs.nix-darwin.lib.darwinSystem {
    inherit (cfg) inputs system;
    pkgs = self.legacyPackages.${cfg.system};
    modules = import ../modules cfg;
    specialArgs = { inherit self; inherit (cfg) hostConfig; };
  };
in
builtins.mapAttrs
  (k: v:
  let a = args // { hostConfig.hostName = k; }; in
  mkDarwinSystem (a // (v a)))
  (self.lib.rake ./.)
