#
# GIT heart FZF
#

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
    fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
    cut -c4- | sed 's/.* -> //'
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
    fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
    sed 's/^..//' | cut -d' ' -f1 |
    sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
    fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
    grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
    fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
    cut -d$'\t' -f1
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
bind-git-helper f b t r h
unset -f bind-git-helper

pdf () {
  local DIR open
  declare -A already
  DIR="${HOME}/.cache/pdftotext"
  mkdir -p "${DIR}"
  open='xdg-open'

  {
    fd -t f -e pdf; # fast, without pdftotext
    fd -t f -e pdf \
      | while read -r FILE; do
    local EXPIRY HASH CACHE
    HASH=$(md5sum "$FILE" | cut -c 1-32)
    # Remove duplicates (file that has same hash as already seen file)
    [ ${already[$HASH]+abc} ] && continue # see https://stackoverflow.com/a/13221491
    already[$HASH]=$HASH
    EXPIRY=$(( 86400 + $RANDOM * 20 )) # 1 day (86400 seconds) plus some random
    CACHE="$DIR/$HASH"
    CMD="pdftotext -f 1 -l 1 '$FILE' - 2>/dev/null | tr \"\n\" \"_\" "
    test -f "${CACHE}" && [ $(expr $(date +%s) - $(date -r "$CACHE" +%s)) -le $EXPIRY ] || eval "$CMD" > "${CACHE}"
    echo -e "$FILE\t$(\cat ${CACHE})"
  done
} | fzf -e  -d '\t' \
  --preview-window up:75% \
  --preview '
v=$(echo {q} | tr " " "|");
echo {1} | rg -i --color=always "$v";
pdftotext -f 1 -l 1 {1} - | rg -i --color=always "$v"' \
  | awk 'BEGIN {FS="\t"; OFS="\t"}; {print "\""$1"\""}' \
  | xargs $open > /dev/null 2> /dev/null
}
