final: prev: {
  zig = final.inputs.zig.packages.${prev.system}.${prev.zig.version};
}
