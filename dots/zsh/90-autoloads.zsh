# Makes bracketed paste smarter.
# Necessary for URL quote to work.
autoload -Uz bracketed-paste-magic
zle -N bracket-paste bracketed-paste-magic

# Auto escape URLs
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

function set-title-precmd() {
  printf "\e]2;%s\a" "${PWD/#$HOME/~}"
}

function set-title-preexec() {
  printf "\e]2;%s\a" "$1"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd set-title-precmd
add-zsh-hook preexec set-title-preexec
