{ callPackage, lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "rnix-lsp";
  version = "f7d5c0026809c05925218386c33db9638b5c60c6";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "rnix-lsp";
    rev = "${version}";

    sha256 = "nl4PWtX1Tr66cfGXCZynMSuBubQyrd6hsJCdhtBFg+A=";
  };

  cargoSha256 = "s9yeu7cwCHUjYvqxMxkq3YibK966WDwaz553xryNkcg=";

  meta = with lib; {
    description = "A work-in-progress language server for Nix, with syntax checking and basic completion";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
  };
}
