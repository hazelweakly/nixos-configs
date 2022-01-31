final: prev: {
  rnix-lsp =
    let naersk-lib = final.inputs.naersk.lib.${prev.system};
    in
    naersk-lib.buildPackage {
      pname = "rnix-lsp";
      root = final.inputs.rnix-lsp;
      doCheck = false;
      checkInputs = [ ]; # No other way to override naersk and set this
    };
}
