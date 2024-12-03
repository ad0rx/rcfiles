# .bashrc

# Disable bash_completion because of bug with variable expansion
shopt -u progcomp
export BW_PROJ="none"
export BW_WS="none"

# When using Tramp and Emacs, there is an issue with using the prompt above
# So only put it into effect after setting a project
#HAPPY_PROMPT="\n\[\e[1;34m\][\$BW_PROJ]\n\[\e[0m\]\[\e[1;31m\][\w]\[\e[0m\]\n[\h] \$> "
HAPPY_PROMPT="\n\[\e[1;34m\][\$BW_WS]\n\[\e[0m\]\[\e[1;31m\][\w]\[\e[0m\]\n[\h] \$> "
export PS1=$HAPPY_PROMPT

# Fix a bug with Emacs Tramp
if [[ $TERM == "dumb" ]]; then
    export PS1="$ "
fi
PATH=${HOME}/scripts:${PATH}
PATH=/usr/local/texlive/2024/bin/x86_64-linux:${PATH}
export PATH

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
alias screen='screen -h 100000'

alias bd='source ${HOME}/projects/bus_defender/bus_defender_env'
alias mcdma='source ${HOME}/projects/mcdma/mcdma_env'

alias pd='popd > /dev/null'
alias cd='pushd > /dev/null'
alias pa='while popd -n; do next; done &> /dev/null'

# Used in the dkr alias to delay expansion of DISPLAY variable until
# the alias is invoked
function get_display () {
    echo ${DISPLAY}
}

export XIL_DKR=xilinx-2022.2-003
alias xil='xhost +; docker exec -e USER=dkr -e DISPLAY=$(get_display) -it ${XIL_DKR} bash'

export PLNX_DKR=petalinux-2022.2-001
alias plnx='xhost +; docker exec -e USER=dkr -e DISPLAY=$(get_display) -it ${PLNX_DKR} bash'

alias gs='git status -u --ignored'
alias gc='git commit'
alias gl='git log --raw'

alias xt='xterm -fa \"Monospace\" -fs 14'
