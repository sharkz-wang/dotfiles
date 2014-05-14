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

export TERM='xterm-256color'
export PS1='%B%F{252}[%f%F{208}%*%f%F{252}]%f %F{118}%n%f%F{252}@%f%F{135}%m%f%F{252}:%f%F{81}%~%f$(BRANCH=$(git branch 2>/dev/null | \grep "^*" | colrm 1 2); echo ${BRANCH:+"%F{252}-(%f%F{161}${BRANCH}%f%F{252})%f"};)%F{252}%(!.#.$)%f %b'
export PATH="${HOME}/script:${HOME}/bin:${PATH}"
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

alias egrep='egrep --color=always'
alias grep='grep --color=always'

alias less='less -R'

alias ls='ls --color=always -p'
alias ll='ls -l'

alias irssi='TERM=screen irssi'

alias ding='/bin/echo -e "\a"'

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

eval `dircolors ${HOME}/.dircolors`

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source "${HOME}/.zshsyntaxcolors"

# Tab-to-list
function expand-or-complete-or-list-files() {
	if [[ $#BUFFER == 0 ]]; then
		echo -e "\r"
		ls --color -C --width=${COLUMNS} -p | perl -pe 'chomp if eof'
		zle accept-line
	else
		zle expand-or-complete
	fi
}

# Bind to tab
bindkey '^I' expand-or-complete-or-list-files
zle -N expand-or-complete-or-list-files
# End tab-to-list

# Go up one level by ctrl + backslash
# Bind to ctrl + backslash
function up-one-level() {
	cd ..
	zle accept-line
}

bindkey '^\\' up-one-level
zle -N up-one-level
# End 

# Previous / next page
export FORWARD_HIST=''
export BACKWARD_HIST=''

function cd() {
	
	if [ -z $BACKWARD_HIST ]; then
		BACKWARD_HIST=${PWD}
	else
		BACKWARD_HIST=${PWD}:${BACKWARD_HIST}
	fi
	FORWARD_HIST=''

	builtin cd $@
}

function forward() {
	
	if [ -z $FORWARD_HIST ]; then
		return 0
	fi

	NEXT=$(echo $FORWARD_HIST | awk -F':' '{ print $1}')
	FORWARD_HIST=$(echo $FORWARD_HIST | \egrep -o ':.*' | sed 's/^.//')
	if [ -z $BACKWARD_HIST ]; then
		BACKWARD_HIST=${PWD}
	else
		BACKWARD_HIST=${PWD}:${BACKWARD_HIST}
	fi

	builtin cd ${NEXT}
	unset NEXT

	zle accept-line
}

function backward() {
	
	if [ -z $BACKWARD_HIST ]; then
		return 0
	fi

	NEXT=$(echo $BACKWARD_HIST | awk -F':' '{ print $1}')
	BACKWARD_HIST=$(echo $BACKWARD_HIST | \egrep -o ':.*' | sed 's/^.//')
	if [ -z $FORWARD_HIST ]; then
		FORWARD_HIST=${PWD}
	else
		FORWARD_HIST=${PWD}:${FORWARD_HIST}
	fi

	builtin cd ${NEXT}
	unset NEXT

	zle accept-line
}

bindkey '^F' forward
zle -N forward 
bindkey '^B' backward
zle -N backward
# End previous / next page functionality

tmuxrc.sh
