() { # remove zsh4human paths
  # When I wrote this, only the gods and I understood it
  # and now, who knows?
  path=(${path:#${~${(j:|:)@}}})
} {$Z4H/zsh4humans/zb,$Z4H/fzf/bin}

() { # Move nix paths to the front of the first non nix-store paths and prune non existing entries
  local idx=$((${path[(i)/(usr|Library|bin|sbin)/*]} - 1))
  path=(${path[1,idx]} $@ ${path[idx,-1]})
  path=(${(@)^path}(-FN))
} {/run/current-system/sw/bin,~/.nix-profile/bin,/etc/profiles/per-user/$USER/bin,/nix/var/nix/profiles/default/bin}

() { # remove non-existing directories
  fpath=(${(@)^fpath}(-FN))
}

[ -d "$HOME/.local/bin" ] && path+=($HOME/.local/bin)
fpath+=("$ZDOTDIR/config/completions" "$ZDOTDIR/config/fn")
