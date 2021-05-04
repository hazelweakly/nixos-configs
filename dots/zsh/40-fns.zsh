list_all() {
  [[ -t 1 ]] || return
  [[ -z "$TTY" ]] && return
  emulate -L zsh
  exa --group-directories-first --icons --sort time >$TTY
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

mcd() { [[ $# == 1 ]] && mkdir -p -- "$1" && cd -- "$1" }
compdef _directories mcd

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

nixpkgs() {
  nix eval --impure --expr '<nixpkgs>'
}

nixcd() {
  cd $(nixpkgs)
}

nixos-option() {
  command nixos-option -I nixpkgs=/etc/nixos/compat "$@"
}

dev-ghc() {
  v="$1"
  shift
  nix-shell -p "haskell.packages.ghc$v.ghcWithPackages (p: [p.zlib p.haskell-language-server p.cabal-fmt])" cabal-install zlib.all xz.all "$@"
}

with-ghc() {
  v="$1"
  shift
  nix-shell -p "haskell.packages.ghc$v.ghcWithPackages (p: [p.zlib])" cabal-install zlib.all xz.all "$@"
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
        zinit update -r -q --all --parallel && \
        zinit creinstall %HOME/.config/zsh/completions && \
        fd -uu -e zwc . $HOME -x rm -f 2>/dev/null && \
        rm -rf ~/.config/zsh/.zcompdump* && \
        zinit compile --all
}

# update() {
#     echo "Rebuilding"
#     build(){
#       set -x
#       sudo \
#         NIX_PATH="$(tr ':' '\n' <<<"$NIX_PATH" | grep -v nixpkgs-overlays | paste -s -d':')" \
#         nixos-rebuild \
#           -I $(tr ':' '\n' <<<"$NIX_PATH" | grep -v nixpkgs-overlays | paste -s -d '%' | sed 's/%/ -I /g') \
#           --flake \
#           '/etc/nixos#'"$(hostname)" \
#           --impure \
#           "$@" \
#           switch
#       set +x
#     }
#     build "$@" && build "$@"
# }

update () {
  echo "Rebuilding"
  sudo nixos-rebuild \
    --flake '/etc/nixos#'"$(hostname)" \
    ${1+"$@"} switch
  }

vup() {
  nvim --headless '+PlugUpgrade' '+PlugUpdate' '+PlugClean!' '+CocUpdateSync' '+qall' ; echo
}
