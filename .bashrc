export TERM='xterm-256color'
export PS1='\e[1;32m\u\e[m\e[1;37m@\e[m\e[1;35m\h\e[m\e[1;37m:\e[m\e[1;36m\W\e[m\e[1;37m\$ '
export PATH="${HOME}/script:${HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/lib"

export LANG='en_US.utf8'
export LC_CTYPE='en_US.utf8'

export EDITOR='vim'

stty -ixon
unset IGNOREEOF

alias ..='cd ..'
alias ...='cd ../..'

alias vim='vim -p'

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

alias irssi='TERM=screen irssi'

alias ding='/bin/echo -e "\a"'

eval `dircolors ${HOME}/.dircolors`

tmuxrc.sh
