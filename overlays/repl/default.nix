final: prev:
let
  example = command: desc: ''\n\u001b[33m ${command}\u001b[0m - ${desc}'';
in
{
  repl = final.writeShellScriptBin "repl" ''
    case "$1" in
      "-h"|"--help"|"help")
        printf "%b\n\e[4mUsage\e[0m: \
          ${example "repl" "Loads system flake if available."} \
          ${example "repl /path/to/flake.nix" "Loads specified flake."}\n"
      ;;
      *)
        if [ -z "$1" ]; then
          nix repl --file ${./repl.nix}
        else
          nix repl --arg flakePath $(${final.coreutils}/bin/readlink -f $1 | ${final.gnused}/bin/sed 's|/flake.nix||') --file ${./repl.nix}
        fi
      ;;
    esac
  '';
}
