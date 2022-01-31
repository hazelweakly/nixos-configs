final: prev: {
  rnix-lsp =
    let naersk-lib = final.inputs.naersk.lib.${prev.system};
    in
    # fuckin fuck everything
    naersk-lib.buildPackage {
      pname = "rnix-lsp";
      root = final.inputs.rnix-lsp;
      doCheck = false;
      checkInputs = [ ];
    };
  # rnix-lsp = final.inputs.rnix-lsp.packages.${prev.system}.rnix-lsp.overrideAttrs (o: {
  #   doCheck = false;
  #   checkInputs = [ ];
  #   nativeBuildInputs = prev.lib.filter (drv: prev.lib.getName drv != "nix") (o.nativeBuildInputs or [ ]);
  # });
}
