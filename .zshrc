source ~/script/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle heroku
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found

# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-syntax-highlighting

# Load the theme.
# Antigen theme

# Tell antigen that you're done.
antigen apply

# Tab-to-list
# Bind to tab
bindkey '^I' expand-or-complete-or-list-files

function expand-or-complete-or-list-files() {
	if [[ $#BUFFER == 0 ]]; then
		echo -e "\r"
		ls --color -C --width=${COLUMNS} -p | perl -pe 'chomp if eof'
		zle accept-line
	else
		zle expand-or-complete
	fi
}

zle -N expand-or-complete-or-list-files
# End tab-to-list

# Go up one level by ctrl + backslash
# Bind to ctrl + backslash
bindkey '^\\' up-one-level

function up-one-level() {
	cd ..
	zle accept-line
}

zle -N up-one-level
# End 

export TERM='xterm-256color'
export PS1='%B%F{252}[%f%F{208}%*%f%F{252}]%f %F{118}%n%f%F{252}@%f%F{135}%m%f%F{252}:%f%F{81}%~%f$(BRANCH=$(git branch 2>/dev/null | grep "^*" | colrm 1 2); echo ${BRANCH:+"%F{252}-(%f%F{161}${BRANCH}%f%F{252})%f"};)%F{252}%(!.#.$)%f %b'
export PATH="${PATH}:${HOME}/script:${HOME}/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/lib"

export LANG='en_US.utf8'
export LANGUAGE='en_US.utf8'
export LC_ALL='en_US.utf8'

export EDITOR='vim'

stty -ixon
unset IGNOREEOF

alias ..='cd ..'
alias ...='cd ../..'

alias vim='TERM=screen-256color vim -p'

alias ls='ls --color=auto -p'
alias ll='ls -l'
alias grep='grep --color=auto'

alias irssi='TERM=screen irssi'

alias ding='/bin/echo -e "\a"'

eval `dircolors ${HOME}/.dircolors`

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source "${HOME}/.zshsyntaxcolors"

tmuxrc.sh
