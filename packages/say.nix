{ writeShellScriptBin, espeak }:
writeShellScriptBin "say" ''
  echo "$@" | ${espeak}/bin/espeak
''
