list_all() {
  emulate -L zsh
  lsd --group-dirs first -t
}
chpwd_functions=(${chpwd_functions[@]} "list_all")

mcd() { mkdir -p "$@"; cd "$@" }

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
        fd -uu -e zwc . $HOME -x rm -f 2>/dev/null && \
        rm -rf ~/.config/zsh/.zcompdump && \
        zini compile --all
}

update() {
    echo "Downloading sources"
    nix eval --raw 'builtins.toJSON (builtins.removeAttrs (import /etc/nixos/nix {}).sources ["__functor"])' >/dev/null 2>&1
    echo "Rebuilding"
    sudo nixos-rebuild \
      -I "nixpkgs=$(nix eval --raw '(import /etc/nixos/nix {}).sources.nixpkgs.outPath')" \
      -I "nixos-config=/etc/nixos/configuration.nix" \
      -I "nixpkgs-overlays=/etc/nixos/nix/overlays-compat/" \
      switch
}
