# .bashrc

#export HOME=/home/bwhitlock/03_peraton_laptop

# Disable bash_completion because of bug with variable expansion
shopt -u progcomp
export PROJ="none"
export PS1="\n\[\e[1;34m\][\$PROJ]\n\[\e[0m\]\[\e[1;31m\][\w]\[\e[0m\]\n[\h] \$> "
export PATH=${HOME}/scripts:~/.local/bin:${PATH}

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export SHELL=/usr/bin/bash

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
export EDITOR=emacs

# Unlimited history
HISTSIZE=-1
HISTFILESIZE=-1

TZ='America/New_York'; export TZ
#TZ='America/Denver'; export TZ

# Project Setup
#export COMMON_DIR=/projects/common
#source ${COMMON_DIR}/bin/common_lib.sh

# User specific aliases and functions
alias ls='ls -lh --color'
alias screen='screen -h 10000'
#alias mc='xterm -geometry 138x36+257+140 -e mc'
#alias mail='mail -f ${HOME}/Maildir --'
#alias minicom='sudo minicom -D /dev/ttyUSB1'

alias bd='source ${HOME}/projects/bus_defender/bus_defender_env'

alias pws='pushd ${PWS} > /dev/null'
alias pd='popd > /dev/null'
alias cd='pushd > /dev/null'
alias pa='while popd -n; do next; done &> /dev/null'

# Used in the dkr alias to delay expansion of DISPLAY variable until
# the alias is invoked
function get_display () {
    echo ${DISPLAY}
}
alias dkr='xhost +; docker exec -e DISPLAY=$(get_display) -it $(docker ps -a | grep -oe '^[0-9a-z]*') bash'

alias gs='git status'
alias gc='git commit'
alias gl='git log --raw'

alias xt='xterm -fa \"Monospace\" -fs 14'

CNAME="vivado-2022.2-001"
alias e="docker exec -it ${CNAME} bash"

alias xpras='xpra start --start-child="xterm -fa \"Monospace\" -fs 14" --exit-with-children ssh:bwhitlock@hc14'
