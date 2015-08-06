# Installation
# 1) git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# 2) cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git

export ZSH="${HOME}/.oh-my-zsh"
plugins=(git zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

unsetopt AUTO_NAME_DIRS
autoload -U zmv

export TERM='xterm-256color'
export PS1='%B%F{252}[%f%F{208}%D{%H:%M:%S}%f%F{252}]%f %F{118}%n%f%F{252}@%f%F{135}%m%f%F{252}:%f%F{81}%~%f$(BRANCH=$(git branch 2>/dev/null | \grep "^*" | colrm 1 2); echo ${BRANCH:+"%F{252}-(%f%F{161}${BRANCH}%f%F{252})%f"};)%(?.%F{252}.%F{161})%(!.#.$)%f %b'
export PATH="${HOME}/script:${HOME}/local/tmp/bin:${HOME}/local/bin:${PATH}:${HOME}/.gem/ruby/2.1.0/bin"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/local/tmp/lib:${HOME}/local/lib"
export PYTHONPATH="${PYTHONPATH}:${HOME}/local/lib/python2.7/site-packages"

export HISTCONTROL=ignorespace

export LANG='en_US.utf8'
export LANGUAGE='en_US.utf8'
export LC_ALL='en_US.utf8'

export EDITOR='vim'

stty -ixon
unset IGNOREEOF

alias e='emacs -nw'
alias vim='TERM=screen-256color vim -p'
alias irssi='TERM=screen irssi'
alias mutt='TERM=screen-256color mutt'

alias ..='cd ..'
alias ...='cd ../..'

alias ls='ls --color=always -p'
alias ll='ls -lh'

alias less='less -R'

unset GREP_OPTIONS
alias egrep='egrep --color=always'
alias grep='grep --color=always'

alias cp='rsync -avh -P'

alias builddb='ctags -R && cscope -Rkbq && (find . -name "*.h" -exec echo "-include {}" \; > .clang_complete)'

alias today='date +%Y%m%d'

alias beep='/bin/echo -e "\a"'

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

bindkey '^U' backward-kill-line
bindkey '^K' kill-line

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

foreground-vim() {
	fg %'TERM=screen-256color vim -p'
}
zle -N foreground-vim
bindkey '^Z' foreground-vim

# Tmux pane fetched auto-completion
tmux_pane_autocomplete() {
	list=($(tmux capture-pane \; show-buffer \; delete-buffer 2>/dev/null | perl -pe 's/[^a-zA-Z0-9:\.\/\-\+\_]+/ /g; s/(\B[:]|[:]\B)/ /g;'))
	_wanted values null '' compadd -a list
}

#bindkey '^E' tmux-pane-autocomplete
#zle -C tmux-pane-autocomplete complete-word _generic
#zstyle ':completion:tmux-pane-autocomplete:*' completer tmux_pane_autocomplete
# End tmux pane fetched auto-completion

alias fuck='eval $(thefuck $(fc -ln -1))'

export THEFUCK_RULES='DEFAULT_RULES'
export THEFUCK_REQUIRE_CONFIRMATION='true'
export THEFUCK_WAIT_COMMAND=10
export THEFUCK_NO_COLORS='false'
