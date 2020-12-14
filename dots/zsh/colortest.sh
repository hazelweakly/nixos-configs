#!/usr/bin/env zsh

endl() { tput sgr0; echo }

row() {
    w=$1 s=$2 e=$3

    slice() {
        for i ({$s..$e}) tput setab $i && printf "%${w}s " ${1:+$i}
        endl
    }

    slice; slice true; slice
}

() {
    cols=$COLUMNS ei=$((cols/8 - 2)) ss=$((cols/6 - 2))

    for a (0 1) row $ei $((8*a)) $((8*a + 7))
    endl

    [[ "$1" == "-16" ]] && exit

    for a ({2..41}) row $ss $((6*a + 4)) $((6*a + 9))
    endl
} "$@"

zsh -i -c "$(cat <<'EOF'
() {
  emulate -L zsh -o prompt_percent -o ksh_arrays
  autoload -Uz zmathfunc && zmathfunc
  local bg fg
  local -i i r g b
  for i in {0..$((COLUMNS-1))}; do
    b='i * 255 / COLUMNS'
    r='255 - b'
    g='255 - abs(r - b)'
    printf -v bg '%02x' $r $g $b
    print -nP "%K{#$bg} "
  done
  print
}
EOF
)"
