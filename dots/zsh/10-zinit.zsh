[[ -d "$XDG_DATA_HOME/zsh/zinit/bin" ]] && () {
    zinit lucid depth'1' light-mode for chisui/zsh-nix-shell romkatv/powerlevel10k

    # Run interactively
    # zinit creinstall %HOME/.config/zsh/completions

    zinit depth'1' wait lucid for \
        blockf zsh-users/zsh-completions \
        hlissner/zsh-autopair \
        Tarrasch/zsh-bd \
        wfxr/forgit \
        zsh-users/zsh-history-substring-search \
        MichaelAquilina/zsh-you-should-use \
        compile'{src/*.zsh,src/strategies/*}' atload'_zsh_autosuggest_start' \
            zsh-users/zsh-autosuggestions

    zinit ice depth'1' wait'1' atinit'zicompinit; zicdreplay' atpull'fast-theme -q XDG:theme' lucid
    zinit light zdharma/fast-syntax-highlighting
}
