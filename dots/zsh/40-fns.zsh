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
    nix run "nixpkgs.$init" -c ${@:-$init}
}

nrr() {
  init="$1"
  shift
  nix run "nixpkgs.$init" -c $init $@
}

ncp() {
  nix eval "(with (import <nixpkgs> {}); callPackage $1 {})"
}

nixpkgs() {
  nix eval --raw '(with (import <nixpkgs> {}); pkgs.sources.nixpkgs.outPath)'
}

nixcd() {
  cd $(nixpkgs)
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
    zini self-update && \
        zini update -r -q --all --parallel && \
        zini creinstall %HOME/.config/zsh/completions && \
        fd -uu -e zwc . $HOME -x rm -f 2>/dev/null && \
        rm -rf ~/.config/zsh/.zcompdump* && \
        zini compile --all
}

update() {
    echo "Downloading sources"
    nix eval --raw '(builtins.toJSON (builtins.removeAttrs (import /etc/nixos/nix {}).sources ["__functor"]))' >/dev/null 2>&1
    nixpkgs="$(nix eval --raw '(import /etc/nixos/nix {}).sources.nixpkgs.outPath')"
    echo "Rebuilding"
    build(){
      sudo nixos-rebuild -k \
        -I "nixpkgs=$nixpkgs" \
        -I "nixos-config=/etc/nixos/configuration.nix" \
        -I "nixpkgs-overlays=/etc/nixos/nix/overlays-compat/" \
        "$@" \
        switch
    }
    build && build
}

vup() {
  nvim --headless +PlugUpgrade +PlugDiff +PlugUpdate +PlugClean! +CocUpdateSync +qall
}
