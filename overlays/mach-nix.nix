final: prev: {
  mach-nix = final.inputs.mach-nix.packages."${prev.system}".mach-nix // {
    mach-nix = final.inputs.mach-nix.packages"${prev.system}".mach-nix;
  } // final.inputs.mach-nix.lib."${prev.system}";
}
