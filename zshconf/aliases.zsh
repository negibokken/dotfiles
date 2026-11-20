case $OSTYPE in
darwin*) alias ls='ls -G' ;;
linux*) alias ls='ls --color' ;;
esac
alias l='ls -lt'
alias la='ls -lta'
alias dotfiles='cd "$DOTFILES"'
alias br='cd "$SECOND_BRAIN"'

alias v=nvim vi=nvim vim=nvim
alias vio='nvim -O'
alias vit='nvim -O "/tmp/$(uuid)"'
alias viu='nvim -u NONE'
alias grep='grep --color'
alias egrep='grep -E --color'
alias cp='cp -i'
alias chx='chmod +x'
alias cd='cd -P'
alias mkdir='mkdir -p'
alias sudo='sudo '
alias python=python3 pip=pip3

alias g=git
alias gad='git add'
alias gst='git status'
alias grt='git rev-parse --show-toplevel'
alias wip='git add -A && git commit -m "wip" --no-verify'
alias wipp='git add -A && git commit -m "wip" --no-verify && git push --no-verify origin "$(git branch --show-current)"'
alias gp=ghq-peco
alias hb='gh browse'
alias difit-main='difit . main'

alias gcp=gcloud
alias dcku='docker compose up'
alias dckd='docker compose down'
alias kube=kubectl k=kubectl
alias alp='docker run -it -v "$PWD:/app" -w /app --rm alpine /bin/sh'
alias ub='docker run -it -v "$PWD:/app" -w /app --rm ubuntu /bin/bash'
alias dw='docker run --rm -v "$PWD:/work" -w /work -it myubuntu /bin/bash'
alias pk=peco-pkill dpk=peco-dpkill dex=peco-dpexec
alias ns=peco-node-scripts
alias bl='ls -1 btools'
alias x='exec "$SHELL" -l'
alias 0xED='open -a 0xED'

alias -g L='| less' G='| grep' X='| xargs' H='| head'
alias -g T='| tee -a "/tmp/sh-$(date +%y-%m-%d).log"'
alias '..'='cd ..'
alias -g ...='../..' ....='../../..' .....='../../../..'
