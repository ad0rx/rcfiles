# .bashrc

# Disable bash_completion because of bug with variable expansion
shopt -u progcomp
export PROJ="none"
export PS1="\n\[\e[1;34m\][\$PROJ]\n\[\e[0m\]\[\e[1;31m\][\w]\[\e[0m\]\n[\h] \$> "
#export PATH=${HOME}/scripts:${PATH}

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
export EDITOR=emacs

# Project Setup
#export COMMON_DIR=/projects/common
#source ${COMMON_DIR}/bin/common_lib.sh

# User specific aliases and functions
alias ls='ls -lh --color'
alias screen='screen -D -R'
alias mc='xterm -geometry 138x36+257+140 -e mc'
alias mail='mail -f ${HOME}/Maildir --'
alias minicom='sudo minicom -D /dev/ttyUSB1'

