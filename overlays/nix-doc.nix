final: prev: {
  nix-doc = prev.nix-doc.overrideAttrs (o: {
    nativeBuildInputs = builtins.filter (p: (p.pname or "") != "nix") o.nativeBuildInputs ++ [ prev.nixUnstable ];
    buildInputs = builtins.filter (p: (p.pname or "") != "nix") o.buildInputs ++ [ prev.nixUnstable ];
  });
}
