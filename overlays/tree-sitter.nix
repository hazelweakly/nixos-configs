final: prev: {
  # tree-sitter = prev.tree-sitter.override (o: {
  #   rustPlatform = prev.rustPlatform // {
  #     buildRustPackage = args: prev.rustPlatform.buildRustPackage (args // rec {
  #       version = "0.22.6";
  #       src = prev.fetchFromGitHub {
  #         owner = "tree-sitter";
  #         repo = "tree-sitter";
  #         rev = "v${version}";
  #         hash = "sha256-jBCKgDlvXwA7Z4GDBJ+aZc52zC+om30DtsZJuHado1s=";
  #         fetchSubmodules = true;
  #       };
  #       cargoHash = "sha256-44FIO0kPso6NxjLwmggsheILba3r9GEhDld2ddt601g=";
  #     });
  #   };
  # });
}
