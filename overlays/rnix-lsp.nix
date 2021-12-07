final: prev: {
  rnix-lsp = final.inputs.rnix-lsp.packages.${prev.system}.rnix-lsp;
}
