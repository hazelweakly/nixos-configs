zstyle ':completion:*' use-compctl false
zstyle ':completion:*:complete:*' use-cache 1
zstyle ':completion:*:complete:*' cache-path $ZSH_CACHE_DIR
zstyle ':completion:*:*:*:*:*' menu true select search interactive
function _files_enhance() {
    _files -M '' \
        -M 'm:{[:lower:]-}={[:upper:]_}' \
        -M 'r:|[.,_-]=* r:|=*' \
        -M 'r:|.=* r:|=*'
}
zstyle ':completion:*' completer _expand_alias _complete _extensions _match _approximate _ignored _files_enhance
zstyle ':completion:*' regular false
zstyle ':completion:*' list-grouped false
zstyle ':completion:*' list-separator ''
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true
zstyle ':completion:*:*:*:*'   file-patterns '^*.(zwc|pyc):compiled-files' '*:all-files'
zstyle ':completion:*:*:rm:*'  file-patterns '*:all-files'
zstyle ':completion:*:*:gio:*' file-patterns '*:all-files'
zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'
setopt complete_in_word
