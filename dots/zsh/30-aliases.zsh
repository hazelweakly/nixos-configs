alias cat='bat --style full'
alias ls='exa --group-directories-first --icons --sort time'
alias l='exa --group-directories-first --icons --sort time -al'
alias ll='exa --group-directories-first --icons --sort time -l'
alias bc='bc -l'

# Ahh, good times, good times...
alias door='sshpass -p "ps aux | grep fixme *" ssh -o StrictHostKeyChecking=no root@nfs ./RelayExec64'
