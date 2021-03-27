if [[ -z "$__SOURCED_PERSONAL_PATH" && -d $HOME/.local/bin ]]; then
    path+=($HOME/.local/bin)
    fpath+=($HOME/.config/zsh/completions)
    export PATH FPATH
fi
__SOURCED_PERSONAL_PATH=1
