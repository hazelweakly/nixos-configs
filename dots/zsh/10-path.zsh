[ -d "$HOME/.local/bin" ] && path+=($HOME/.local/bin)
fpath+=("$ZDOTDIR"/config/{completions,fn})

() { # remove zsh4human paths
  # When I wrote this, only the gods and I understood it
  # and now, who knows?
  #
  # j:|: joins the array with the delimiter |
  # ~${} forces the string to be treated as a pattern
  # ${a:#pat} removes anything matching the pattern from the array
  path=(${path:#${~${(j:|:)@}}})
} {$Z4H/zsh4humans/zb,$Z4H/fzf/bin}

() { # remove non-existing nix profiles
  NIX_PROFILES=${(j: :)@}
} ${^=NIX_PROFILES}(-FNoN)

# TODO: Make function that splits a path into
# - all paths prefixed with NIX_PROFILES whatever
# - all non-nix-store paths
# - exactly preserves order
# - removes non-existing entries
# () {
#   local q=^\(${(j:|:)${(z)NIX_PROFILES}}\)
#   local no_nix=${path:#${~(j:|:)${(z)NIX_PROFILES}}}
#   echo ${path:|q}
# }

() { # Move nix paths to the front of the first non nix-store paths and prune non existing entries
  # a[(i)pattern] gets the index of the first element patching the pattern
  local idx=$((${path[(i)/(opt|usr|Library|bin|sbin)/*]} - 1))
  local a=(${path[1,idx]} $@ ${path[idx,-1]})
  # (glob qualifiers)
  # - works on targets of symlinks
  # F - all non empty directories
  # N - sets NULL_GLOB
  # oN - don't sort results
  path=(${(@)^a}(-FNoN))
} ${(z)^NIX_PROFILES}/bin

() {
  local idx=$((${fpath[(i)/(opt|usr|Library|bin|sbin)/*]} - 1))
  local a=(${fpath[1,idx]} $@ ${fpath[idx,-1]})
  fpath=(${(@)^a}(-FNoN))
} ${(z)^NIX_PROFILES}/share/zsh/{site-functions,$ZSH_VERSION/functions,vendor-completions}
