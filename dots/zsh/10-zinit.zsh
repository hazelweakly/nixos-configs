[[ -d "$XDG_DATA_HOME/zsh/zinit/bin" ]] && () {
    zinit lucid depth'1' light-mode for chisui/zsh-nix-shell romkatv/powerlevel10k

    # Run interactively
    # zinit creinstall %HOME/.config/zsh/completions

    zinit light-mode lucid wait has"kubectl" for \
        id-as"kubectl_completion" \
        as"completion" \
        atclone"kubectl completion zsh > _kubectl && sed -i '22 s|^.*$|cat \"\$@\" > \$ZSH_CACHE_DIR/source \&\& source \$ZSH_CACHE_DIR/source|' _kubectl" \
        atpull"%atclone" \
        run-atpull \
        zdharma/null

    zinit depth'1' wait lucid for \
        blockf zsh-users/zsh-completions \
        hlissner/zsh-autopair \
        Tarrasch/zsh-bd \
        wfxr/forgit \
        zsh-users/zsh-history-substring-search \
        MichaelAquilina/zsh-you-should-use \
        atload'_zsh_autosuggest_start' \
            zsh-users/zsh-autosuggestions

    zinit ice depth'1' wait'1' atload'zicompinit; zicdreplay' atpull'fast-theme -q XDG:theme' lucid
    zinit light zdharma/fast-syntax-highlighting
}
