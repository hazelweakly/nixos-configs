'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh
  setopt no_unset extended_glob

  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs command_execution_time newline nix_shell pchar)

  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    background_jobs
    direnv
    asdf
    virtualenv
    anaconda
    pyenv
    goenv
    nodenv
    nvm
    nodeenv
    node_version
    go_version
    rust_version
    dotnet_version
    docker_version
    php_version
    laravel_version
    java_version
    package
    rbenv
    rvm
    fvm
    luaenv
    jenv
    plenv
    phpenv
    scalaenv
    kubecontext
    terraform
    aws
    aws_eb_env
    azure
    gcloud
    google_app_cred
    context
    nordvpn
    ranger
    nnn
    vim_shell
    midnight_commander
    vpn_id
    todo
    time
    taskwarrior
    newline
    timewarrior
  )

  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=false

  typeset -g POWERLEVEL9K_NIX_SHELL_CONTENT_EXPANSION=
  typeset -g POWERLEVEL9K_PCHAR_{NIX,DIRENV}_VISUAL_IDENTIFIER_EXPANSION='Λ'
  function prompt_pchar() {
    local c='010'
    if (( _p9k__status )); then
        local c='009'
    fi

    local state=${DIRENV_DIR:+DIRENV}
    local state=${IN_NIX_SHELL:+NIX}
    local state=${state:-NORM}

    p10k segment -s $state -f $c -i 'λ'
  }

  function instant_prompt_pchar() {
    p10k segment -s NORM -f '010' -i 'λ'
  }

  function prompt_docker_version() {
    (( $+commands[docker] )) || return
    _p9k_upglob 'Dockerfile|docker-compose.yml' && return
    _p9k_cached_cmd 0 docker --version && [[ $_p9k__ret == D?* ]] || return
    p10k segment -i $'\UF308' -f '014' -t "${${${_p9k__ret//\%/%%}/**, build /}%.*}"
  }

  (( ! $+functions[p10k] )) || p10k reload
}

export ZLE_RPROMPT_INDENT=0
(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
