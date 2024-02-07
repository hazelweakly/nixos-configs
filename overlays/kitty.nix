final: prev: {
  kitty = prev.kitty.overrideAttrs (o: rec {
    nativeBuildInputs = (o.nativeBuildInputs or [ ]) ++ [ prev.makeBinaryWrapper ];
    src = final.inputs.kitty;
    version = "0.32.1";
    goModules = (prev.buildGoModule {
      pname = "kitty-go-modules";
      inherit src version;
      vendorHash = "sha256-N7szgTxUSbT6nylPwdDxU0J5NrdEBsi6u39U+txIXi0=";
    }).goModules;
    buildInputs = o.buildInputs ++ [ prev.simde ];
  });
}
