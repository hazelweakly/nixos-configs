final: prev: {
  python3 = prev.python3.override {
    packageOverrides = _: pyPrev: {
      ipython = pyPrev.ipython.overridePythonAttrs (o: {
        preCheck = o.preCheck + prev.lib.optionalString prev.stdenv.isDarwin ''
          echo '#!${prev.stdenv.shell}' > pbcopy
          chmod a+x pbcopy
          cp pbcopy pbpaste
          export PATH="$(pwd)''${PATH:+":$PATH"}"
        '';
      });
    };
    self = final.python3;
  };
}
