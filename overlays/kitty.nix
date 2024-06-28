final: prev: {
  kitty = prev.kitty.overrideAttrs (o: rec {
    nativeBuildInputs = (builtins.filter (x: (x.pname or "") != "go") (o.nativeBuildInputs or [ ])) ++ [ prev.makeBinaryWrapper prev.go_1_22 ];
    src = final.inputs.kitty;
    version = "0.35.2";
    goModules = (prev.buildGo122Module {
      pname = "kitty-go-modules";
      inherit src version;
      vendorHash = "sha256-4t5szH4H6jPpeSgIWQ4IutP7vnRx8Ui3cM2KZhqTxNA=";
      # vendorHash = prev.lib.fakeHash;
    }).goModules;
    buildInputs = o.buildInputs ++ [ prev.simde ];
  });
}
