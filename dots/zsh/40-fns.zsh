list_all() {
  emulate -L zsh
  lsd --group-dirs first -t
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

mcd() { mkdir "$@"; cd "$@" }

ranger-cd() {
  tempfile="$(mktemp -t tmp.XXXXXX)"
  \ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
    if [ "$(\cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
      cd -- "$(\cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

dedup_history() {
  tac $HISTFILE | awk -F ";" '!x[$2]++' | tac | sponge $HISTFILE
}

src() {
  cd "$HOME/src/$1"
}

gcd() {
    target="$1"
    shift
    git clone "$target" $@ && cd "${"${target##*/}"/.git/}"
}

with() {
    nix-shell -p "$@"
}

nr() {
    # last="${@: -1}"
    # init="${@:1:$(($# - 1))}"
    # init=${init:-$last}
    init="$1"
    shift
    nix run "nixpkgs.$init" -c ${@:-$init}
}

ghc-shell() {
  nix-shell -p "haskellPackages.ghcWithPackages (ps: with ps; [ $* ])"
}

ghci-with() {
  nix-shell \
    -p "haskellPackages.ghcWithPackages (ps: with ps; [ $* ])" \
    --run ghci
}

zup() {
    zini delete --clean && \
        zini self-update && \
        zini update -r -q --all && \
        fd -uu -e zwc -x rm && \
        rm -rf ~/.config/zsh/.zcompdump && \
        zini compile --all
}
