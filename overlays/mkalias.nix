final: prev: {
  mkalias = final.inputs.mkalias.packages.${prev.system}.mkalias.overrideAttrs (o: {
    buildInputs = [ ];
  });
}
