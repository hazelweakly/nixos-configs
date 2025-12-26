final: prev: {
  mkalias = final.inputs.mkalias.packages.${prev.stdenv.hostPlatform.system}.mkalias.overrideAttrs (o: {
    buildInputs = [ ];
  });
}
