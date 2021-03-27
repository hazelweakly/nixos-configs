_allFlags() {
  for varName in $(awk 'BEGIN { for (v in ENVIRON) if (v ~ /^[a-z][a-zA-Z0-9_]*$/) print v }'); do
    if (("${NIX_DEBUG:-0}" >= 1)); then
      printf "@%s@ -> %q\n" "${varName}" "${!varName}"
    fi
    args+=("--subst-var" "$varName")
  done
}

substituteInPlace() {
  local fileName="$1"
  shift
  substitute "$fileName" "$fileName" "$@"
}

substituteAllInPlace() {
  local fileName="$1"
  shift
  substituteAll "$fileName" "$fileName" "$@"
}

substituteAll() {
  local input="$1"
  local output="$2"

  local -a args=()
  _allFlags

  substitute "$input" "$output" "${args[@]}"
}

substitute() {
  local input="$1"
  local output="$2"
  shift 2

  if [ ! -f "$input" ]; then
    echo "substitute(): ERROR: file '$input' does not exist" >&2
    return 1
  fi

  local content
  consumeEntire content < "$input"

  if [ -e "$output" ]; then chmod +w "$output"; fi
  substituteStream content "file '$input'" "$@" > "$output"
}

consumeEntire() {
  # read returns non-0 on EOF, so we want read to fail
  if IFS='' read -r -N 0 $1; then
    echo "consumeEntire(): ERROR: Input null bytes, won't process" >&2
    return 1
  fi
}

substituteStream() {
  local var=$1
  local description=$2
  shift 2

  while (("$#")); do
    case "$1" in
      --replace)
        pattern="$2"
        replacement="$3"
        shift 3
        local savedvar
        savedvar="${!var}"
        eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
        if [ "$pattern" != "$replacement" ]; then
          if [ "${!var}" == "$savedvar" ]; then
            echo "substituteStream(): WARNING: pattern '$pattern' doesn't match anything in $description" >&2
          fi
        fi
        ;;

      --subst-var)
        local varName="$2"
        shift 2
        # check if the used nix attribute name is a valid bash name
        if ! [[ "$varName" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
          echo "substituteStream(): ERROR: substitution variables must be valid Bash names, \"$varName\" isn't." >&2
          return 1
        fi
        if [ -z ${!varName+x} ]; then
          echo "substituteStream(): ERROR: variable \$$varName is unset" >&2
          return 1
        fi
        pattern="@$varName@"
        replacement="${!varName}"
        eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
        ;;

      --subst-var-by)
        pattern="@$2@"
        replacement="$3"
        eval "$var"'=${'"$var"'//"$pattern"/"$replacement"}'
        shift 3
        ;;

      *)
        echo "substituteStream(): ERROR: Invalid command line argument: $1" >&2
        return 1
        ;;
    esac
  done

  printf "%s" "${!var}"
}
