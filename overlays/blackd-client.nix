final: prev: {
  blackd-client = prev.rustPlatform.buildRustPackage rec {
    pname = "blackd-client";
    version = "v0.0.6";

    src = prev.fetchFromGitHub {
      owner = "disrupted";
      repo = pname;
      rev = version;
      sha256 = "sha256-4jn4x0EBJH5oVavHFDwUgg+S01Ma2/YlfZB6Qae1MO4=";
    };

    cargoSha256 = "sha256-AfLGxY96oz6oOoIcQ8ZpnR4kRRXXsp2IDYi8gT3Y5PI=";

    doCheck = false;
  };
}
