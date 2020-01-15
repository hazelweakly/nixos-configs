[[ -d "$XDG_DATA_HOME/zsh/zplugin/bin" ]] && () {
    zplugin ice lucid
    zplugin light chisui/zsh-nix-shell

    zplugin ice depth=1 lucid
    zplugin light romkatv/powerlevel10k

    zplugin ice lucid
    zplugin light mafredri/zsh-async

    zplugin ice wait'0' blockf atpull'zplugin creinstall -q .' lucid
    zplugin light zsh-users/zsh-completions

    zplugin ice wait'0' nocompletions pick'autopair.zsh' lucid
    zplugin light hlissner/zsh-autopair

    zplugin ice wait'0' lucid
    zplugin light Tarrasch/zsh-bd

    zplugin ice wait'0' lucid
    zplugin light zsh-users/zsh-history-substring-search

    zplugin ice wait'0' compile'{src/*.zsh,src/strategies/*}' atload'_zsh_autosuggest_start' lucid
    zplugin light zsh-users/zsh-autosuggestions

    zplugin ice wait'1' lucid
    zplugin light MichaelAquilina/zsh-you-should-use

    zplugin ice wait'1a' pick'zsh/fzf-zsh-completion.sh' lucid
    zplugin light lincheney/fzf-tab-completion

    zplugin ice wait'1b' lucid
    zplugin light Aloxaf/fzf-tab

    zplugin ice depth'1' wait'2' atinit"zpcdreplay" lucid
    zplugin light zdharma/fast-syntax-highlighting
}
