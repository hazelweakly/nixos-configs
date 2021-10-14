list_all() {
  [[ -t 1 ]] || return
  [[ -z "$TTY" ]] && return
  emulate -L zsh
  exa --group-directories-first --icons --sort time >$TTY
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

mcd() { [[ $# == 1 ]] && { mkdir -p -- "$1" && cd -- "$1" } || : }

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
    init="$1"
    shift
    nix shell "nixpkgs#$init" -c ${@:-$init}
}

nrr() {
  init="$1"
  shift
  nix run "nixpkgs#$init" -- "$@"
}

ncp() {
  nix eval "(with (import <nixpkgs> {}); callPackage $1 {})"
}

nixcd() {
  v="${1:-nixpkgs}"
  builtin cd /etc/nix/inputs/"$v"
}

nixos-option() {
  command nixos-option -I nixpkgs=/etc/nixos/compat "$@"
}

dev-ghc() {
  v="$1"
  shift
  nix-shell -p "haskell.packages.ghc$v.ghcWithPackages (p: [p.zlib p.haskell-language-server p.cabal-fmt])" cabal-install zlib.all xz.all "$@"
}

# with-ghc() {
#   v="$1"
#   shift
#   nix-shell -p "haskell.packages.ghc$v.ghcWithPackages (p: [p.zlib])" cabal-install zlib xz "$@"
# }

with-ghc() {
  v="$1"
  shift
  nix-shell -p "haskell.packages.ghc$v.ghc" cabal-install zlib xz "$@"
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
  zinit self-update && \
    fd -uu -e zwc . $HOME -x rm -f 2>/dev/null && \
    zinit update -r -u -q --all --parallel && \
    zinit creinstall %HOME/.config/zsh/completions && \
    fd -uu -e zwc . $HOME -x rm -f 2>/dev/null && \
    rm -rf ~/.config/zsh/.zcompdump* && \
    zinit compile --all && zinit self-update
}

update () {
  echo "Rebuilding"
  darwin-rebuild --flake /Users/hazelweakly/src/personal/nixos-configs ${1+"$@"} switch
  rm -f /Users/hazelweakly/src/personal/nixos-configs/result
  # sudo nixos-rebuild \
  #   --flake '/etc/nixos#'"$(hostname)" \
  #   ${1+"$@"} switch
}

vup () {
  nvim --headless '+PlugUpgrade' '+PlugUpdate' '+TSUpdateSync' '+PlugClean!' '+CocUpdateSync' '+qall' ; echo
}
