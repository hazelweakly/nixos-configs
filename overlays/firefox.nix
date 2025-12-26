final: prev: {
  firefox-nightly-bin = if final.stdenv.isLinux then final.inputs.firefox-nightly.packages.${final.stdenv.hostPlatform.system}.firefox-nightly-bin else prev.firefox-devedition-bin;
  firefox-beta-bin = if final.stdenv.isLinux then final.inputs.firefox-nightly.packages.${final.stdenv.hostPlatform.system}.firefox-beta-bin else prev.firefox-beta-bin;
}
