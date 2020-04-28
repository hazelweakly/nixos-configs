{ sources ? import ./sources.nix, system ? builtins.currentSystem }:
let
  moz = import sources.nixpkgs-mozilla;
  niv = _: _: { inherit (import sources.niv { }) niv; };
  lorri = _: _: { lorri = import sources.lorri { }; };
  neuron = _: _: {
    neuron = import sources.neuron { gitRev = sources.neuron.rev; };
  };
  search = _: super: {
    haskellPackages = super.recurseIntoAttrs super.haskellPackages;
    nodePackages = super.recurseIntoAttrs super.nodePackages;
  };
  nur = self: _: {
    nur = import sources.NUR {
      nurpkgs = self;
      pkgs = self;
    };
  };
  srcs = _: _: { inherit sources; };
  intel = self: super: {
    vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
  };
  overlays = [ moz nur srcs lorri niv search intel neuron ];
  config = { allowUnfree = true; };
in import sources.nixpkgs { inherit config overlays system; }
