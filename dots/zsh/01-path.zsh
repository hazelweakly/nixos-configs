if [[ -z "$__SOURCED_PERSONAL_PATH" && -d $HOME/.local/bin ]]; then
    typeset -U path
    path+=($HOME/.local/bin)
    export PATH
fi
__SOURCED_PERSONAL_PATH=1
