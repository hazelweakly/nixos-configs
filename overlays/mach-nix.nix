final: prev: {
  mach-nix = final.inputs.mach-nix.packages.x86_64-linux.mach-nix // {
    mach-nix = final.inputs.mach-nix.packages.x86_64-linux.mach-nix;
  } // final.inputs.mach-nix.lib.x86_64-linux;
}
