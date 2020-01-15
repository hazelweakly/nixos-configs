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
