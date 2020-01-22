{ sources ? import ./sources.nix }:
let
  moz = import sources.nixpkgs-mozilla;
  niv = _: _: { inherit (import sources.niv { }) niv; };
  lorri = pkgs: _: { lorri = import sources.lorri { inherit pkgs; }; };
  nur = self: _: {
    nur = import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };
  };
  srcs = _: _: { inherit sources; };
  overlays = [ moz nur srcs lorri niv ];
  config = { allowUnfree = true; };
in import sources.nixpkgs { inherit config overlays; }
