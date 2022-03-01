final: prev: {
  direnv = final.inputs.direnv.outputs.packages.${prev.system}.direnv;
}
