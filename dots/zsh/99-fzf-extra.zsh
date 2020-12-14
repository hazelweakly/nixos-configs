#
# GIT heart FZF
#

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

forgit_log=gh
forgit_diff=gf

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
    sed 's/^..//' | cut -d' ' -f1 |
    sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
    fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
    fzf-down --tac \
    --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
    cut -d$'\t' -f1
}

gs() {
  is_in_git_repo || return
  local filter
  if [ -n $@ ] && [ -f $@ ]; then filter="-- $@"; fi

  git log --date=short --graph --color=always --abbrev=7 --format='%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)' --simplify-by-decoration $@ | fzf-down \
    --ansi --no-sort --reverse --tiebreak=index \
    --preview "f() { set -- \$(echo -- \$@ | grep -o '[a-f0-9]\{7\}'); [ \$# -eq 0 ] || git show --color=always \$1 $filter | delta --paging always; }; f {}" \
    --bind "ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % $filter | delta --paging always') << 'FZF-EOF'
                {}
                FZF-EOF" \
   --preview-window=right:60%
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local char
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h s a i
unset -f bind-git-helper

# bindkey "^F" fzf-complete-generic
# bindkey "^D" fzf-complete-directories
# bindkey "^G" fzf-complete-files
# bindkey "^ " fzf-complete-macro
# bindkey "^Z" fzf-complete-history-commands
# bindkey "^A" fzf-complete-history-words
# bindkey "^T" fzf-complete-history-paths
# bindkey "^P" fzf-complete-git-all-files
# bindkey "^Y" fzf-complete-git-changed-files
