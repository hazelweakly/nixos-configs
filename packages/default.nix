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

  ourPkgs = pkgs: (
    builtins.mapAttrs (_: v: pkgs.legacyPackages.callPackage v { }) (self.lib.rake ./.)
  ) // {
    neovim-bundled = let neovimPath = builtins.toString ./dots/nvim; in pkgs.neovim.passthru.override {
      wrapRc = true;
      wrapperArgs = (pkgs.neovim.passthru.args.wrapperArgs or [ ]) ++ [
        "--add-flags"
        "--cmd 'set packpath^=${neovimPath}'"
        "--add-flags"
        "--cmd 'set rtp^=${neovimPath}'"
      ];
      neovimRcContent = ''
        luafile ${neovimPath + "/init.lua"}
      '';
    };
  };

in
inputs.nixpkgs.lib.fix (inputs.nixpkgs.lib.extends extensions ourPkgs)
