final: prev: {
  kitty = prev.kitty.overrideAttrs (o: rec {
    nativeBuildInputs = (builtins.filter (x: (x.pname or "") != "go") (o.nativeBuildInputs or [ ])) ++ [ prev.makeBinaryWrapper prev.go_1_22 ];
    src = final.inputs.kitty;
    version = "0.32.1";
    goModules = (prev.buildGo122Module {
      pname = "kitty-go-modules";
      inherit src version;
      vendorHash = "sha256-vn+v7u4g/6WxLPFcNxx5fGRIlc9Dy954YwcO6iRkWEo=";
    }).goModules;
    buildInputs = o.buildInputs ++ [ prev.simde ];
  });
}
