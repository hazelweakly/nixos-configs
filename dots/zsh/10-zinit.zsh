[[ -d "$XDG_DATA_HOME/zsh/zinit/bin" ]] && () {
    zinit ice lucid
    zinit light chisui/zsh-nix-shell

    zinit ice depth'1' lucid
    zinit light romkatv/powerlevel10k

    # Run interactively
    # zinit creinstall %HOME/.config/zsh/completions

    zinit ice wait'0' blockf atpull'zinit creinstall -q .' lucid
    zinit light zsh-users/zsh-completions

    zinit ice wait'0' lucid
    zinit light hlissner/zsh-autopair

    zinit ice wait'0' lucid
    zinit light Tarrasch/zsh-bd

    zinit ice wait'0' lucid
    zinit light zsh-users/zsh-history-substring-search

    zinit ice wait'0' compile'{src/*.zsh,src/strategies/*}' atload'_zsh_autosuggest_start' lucid
    zinit light zsh-users/zsh-autosuggestions

    zinit ice wait'1' lucid
    zinit light MichaelAquilina/zsh-you-should-use

    # zinit ice wait'1a' pick'zsh/fzf-zsh-completion.sh' lucid
    # zinit light lincheney/fzf-tab-completion

    zinit ice wait'1b' lucid
    zinit light Aloxaf/fzf-tab

    zinit ice depth'1' wait'2' atinit'zpcompinit; zpcdreplay' atpull'fast-theme -q XDG:q-jmnemonic' lucid
    zinit light zdharma/fast-syntax-highlighting
}
