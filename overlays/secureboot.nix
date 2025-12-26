final: prev: {
  bootspec-secureboot = final.inputs.bootspec-secureboot.defaultPackage.${final.stdenv.hostPlatform.system};
}
