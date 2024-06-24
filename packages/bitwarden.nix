{ lib, bitwarden-cli, flock, writeShellScriptBin, installShellFiles, hello, ... }:
let
  path = lib.makeBinPath
    [ bitwarden-cli flock ];
  bw = writeShellScriptBin "bw" ''
    export PATH=${path}
    token_file=/tmp/bw-token
    lock_file=/tmp/bw-token.lock

    if [[ -e "$token_file" ]]; then
      export BW_SESSION=$(<"$token_file")
    else
      exec 9>"$lock_file"
      while ! flock -n 9; do
        sleep 1
      done
      if [[ -e "$token_file" ]]; then
        export BW_SESSION=$(<"$token_file")
      else
        for i in {1..4}; do
          export BW_SESSION=$(bw unlock --raw)
          if [[ "$BW_SESSION" != "" ]]; then
            echo "$BW_SESSION" > "$token_file"
            break
          fi
        done
      fi
    fi

    exec bw "$@"
  '';
in
hello
# bw.overrideAttrs (o: {
#   buildCommand = o.buildCommand + ''
#     runHook postInstall
#   '';
#   postInstall = ''
#     mkdir -p $out/share/zsh/site-functions
#     HOME=.
#     ${bitwarden-cli}/bin/bw completion --shell zsh > $out/share/zsh/site-functions/_bw
#   '';
#   nativeBuildInputs = (o.nativeBuildInputs or [ ])
#     ++ [ installShellFiles ];
# })
