{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ pulumi-bin gum packer gh jq dasel figlet /* ansible */ google-cloud-sdk ];

  homebrew.taps = [ "equinix-labs/otel-cli" "withgraphite/tap" ];
  homebrew.brews = [ "tailscale" "lxc" "otel-cli" "withgraphite/tap/graphite" ];
}
