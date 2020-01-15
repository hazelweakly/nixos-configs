bindkey '^N' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^U' backward-kill-line
bindkey '^[[Z' reverse-menu-complete

backward-kill-dir () {
  local WORDCHARS='*?[]~=&;!#$%^(){}<>'
  zle backward-kill-word
}
zle -N backward-kill-dir
bindkey '^H' backward-kill-dir
bindkey '^[^?' backward-kill-dir

# Alt+Left
backward-word-dir () {
  local WORDCHARS='*?[]~=&;!#$%^(){}<>'
  zle backward-word
}
zle -N backward-word-dir
bindkey '^[[1;3D' backward-word-dir
bindkey '^[b' backward-word-dir

# Alt+Right
forward-word-dir () {
  local WORDCHARS='*?[]~=&;!#$%^(){}<>'
  zle forward-word
}
zle -N forward-word-dir
bindkey '^[[1;3C' forward-word-dir
bindkey '^[f' forward-word-dir

bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

bindkey '^I' fzf_completion
