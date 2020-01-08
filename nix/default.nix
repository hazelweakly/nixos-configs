{ sources ? import ./sources.nix }:
let
  moz = import sources.nixpkgs-mozilla;
  nur = self: _: {
    nur = import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };
  };
  srcs = _: _: { inherit sources; };
  overlays = [ moz nur srcs ];
  config = { allowUnfree = true; };
in import sources.nixpkgs { inherit config overlays; }
