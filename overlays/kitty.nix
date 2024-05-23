final: prev: {
  kitty = prev.kitty.overrideAttrs (o: rec {
    nativeBuildInputs = (builtins.filter (x: (x.pname or "") != "go") (o.nativeBuildInputs or [ ])) ++ [ prev.makeBinaryWrapper prev.go_1_22 ];
    src = final.inputs.kitty;
    version = "0.32.1";
    goModules = (prev.buildGo122Module {
      pname = "kitty-go-modules";
      inherit src version;
      vendorHash = "sha256-rEG3mmghvEih2swm+2gp/G9EC2YdyjaOnvq+tALC3jo=";
      # vendorHash = prev.lib.fakeHash;
    }).goModules;
    buildInputs = o.buildInputs ++ [ prev.simde ];
  });
}
