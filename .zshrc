# Installation
# 1) git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# 2) cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
# 3) mkdir -p ~/.oh-my-zsh/plugins/docker
# 4) wget https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker -O ~/.oh-my-zsh/plugins/docker/_docker
# 5) Download fzf from https://github.com/junegunn/fzf-bin/releases to ${PATH}
# 6) git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

export ZSH="${HOME}/.oh-my-zsh"
plugins=(git zsh-syntax-highlighting docker)
DISABLE_AUTO_UPDATE="true"
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

export EDITOR='vim -u ~/.vimrc.light'

export LESS_TERMCAP_md=$'\e[01;38;5;118m'  # begin bold
export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
export LESS_TERMCAP_me=$'\e[0m'           # end mode
export LESS_TERMCAP_so=$'\e[48;5;161;246m'    # begin standout-mode - info box
export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
export LESS_TERMCAP_us=$'\e[04;38;5;135m' # begin underline
export LESS_TERMCAP_ue=$'\e[0m'           # end underline

stty -ixon
unset IGNOREEOF

alias e='emacs -nw'
alias vim='TERM=screen-256color vim -p'
alias irssi='TERM=screen irssi'
alias tig='TERM=screen-256color tig'
alias ftig='TERM=screen-256color TIGRC_USER=${HOME}/.tigrc.light tig'
alias mutt='TERM=screen-256color mutt'

alias ..='cd ..'
alias ...='cd ../..'

alias ls='ls --color=always -p'
alias ll='ls -lh'

alias df='df -h'

alias less='less -R'

unset GREP_OPTIONS
alias egrep='egrep --color=always'
alias grep='grep --color=always'

alias cp='rsync -avh -P'
alias scp='rsync -avhz'

alias builddb='ctags -R && cscope -Rkbq && (find . -name "*.h" -exec echo "-include {}" \; > .clang_complete)'

alias today='date +%Y%m%d'

alias beep='/bin/echo -e "\a"'

export FZF_DEFAULT_OPTS='--no-sort --reverse'

alias ggb='git branch | sed "s/[ \*]\+//" | peco'
alias qgbr='git branch --remote | sed "s/[ \*]\+//" | sed "s/ \->.*$//" | peco'
alias qgb='git branch | sed "s/[ \*]\+//" | sed "s/ \->.*$//" | peco'
alias qglol='git log --pretty="%h    %<(26,trunc)%an%<(32,trunc)%cr    %s" | head -n 20 | fzf | awk "{ print \$1 }"'

alias fd='fd --no-ignore --hidden'
alias ag='ag --all-types --hidden'

# allow vi-mode by default, to activate it, press `esc' or `ctrl-['
bindkey -v

bindkey "^[F" forward-word
bindkey "^[B" backward-word

bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

bindkey '^U' backward-kill-line
bindkey '^K' kill-line

quit-history-search() {
	zle backward-char
	zle forward-char
}
bindkey "^G" quit-history-search
zle -N quit-history-search

backward-delete-arg() {
	local WORDCHARS='~!#$%^&*(){}[]<>?.+;-_/\|=@`'
	zle backward-delete-word
}
zle -N backward-delete-arg
bindkey '^W' backward-delete-arg
bindkey '^H' backward-delete-word

eval `dircolors ${HOME}/.dircolors`

#  tab-completion: sort filename by modification date
zstyle ':completion:*' file-sort modification

zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source "${HOME}/.zshsyntaxcolors"

export FZF_BOOKMARK="~"

export FZF_ALT_C_COMMAND="command find -L ${FZF_BOOKMARK} \\( -maxdepth 3 -path '*/\\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
	-o -type d -print 2> /dev/null | sed 1d"

export FZF_CTRL_T_COMMAND="command find -L ${FZF_BOOKMARK} \\( -maxdepth 3 -path '*/\\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 1d"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey '\ez' fzf-cd-widget
bindkey '\ex' fzf-cd-widget
bindkey '\ep' fzf-file-widget
bindkey '\er' fzf-history-widget

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^S" history-incremental-pattern-search-forward

hello_in_c() {
	echo '#include <stdio.h>'
	echo 'int main(void) {\n\tprintf("Hello, World!\\n");\n\treturn 0;\n}'
}

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

# Tab to expand-macro or long list
function expand-macro-or-long-list-files() {
	if [[ $#BUFFER == 0 ]]; then
		echo -e "\r"
		ls -hl --color -p | perl -pe 'chomp if eof'
		zle accept-line
	else
		zle emacs-backward-word
		BUFFER=${LBUFFER}'`'${RBUFFER}
		BUFFER=${BUFFER}'`'
		zle emacs-forward-word
		zle forward-char
		zle expand-or-complete
	fi
}

# Bind to shift + tab
bindkey '^[^I' expand-macro-or-long-list-files
bindkey '^[[Z' expand-macro-or-long-list-files
zle -N expand-macro-or-long-list-files
# End tabbing to expand-macro or long list

# Ctrl+t to start switchable tmux connection
export TMUX_ATTACH_CMD_LIST=${HOME}/.tmux.attach

function tmux-select-session() {
	EXCLUDED_CMD=$1

	# exclude ${EXCLUDED_CMD} if not empty
	if [ -z ${EXCLUDED_CMD} ]
	then
		cat ${TMUX_ATTACH_CMD_LIST} | peco
	else
		cat ${TMUX_ATTACH_CMD_LIST} | grep -v "${EXCLUDED_CMD}" | peco
	fi
}

function tmux-create-switchable-connection() {

	(tmux attach || tmux)
  unset TMUX_ATTACH_CMD

	# prompt session list upon detaching current one
	# can be aborted by pressing C-c on selection prompt
	while true
	do
		# exclude currently attached session ${TMUX_ATTACH_CMD}
		TMUX_ATTACH_CMD=`tmux-select-session ${TMUX_ATTACH_CMD}`

		if [ "${TMUX_ATTACH_CMD}" = "" ]
		then
			break
		fi

		eval "${TMUX_ATTACH_CMD}"
	done
}

function send-tmux-create-switchable-connection() {
	if [[ $#BUFFER == 0 ]]; then
		if [ "${TMUX}" = "" ]; then
			BUFFER='tmux-create-switchable-connection'
			CURSOR=$#BUFFER
			zle accept-line
		fi
	fi
}

# Bind to ctrl + t
bindkey '^T' send-tmux-create-switchable-connection
zle -N send-tmux-create-switchable-connection
# End Ctrl+t to start switchable tmux connection
# Go up one level by ctrl + backslash
# Bind to ctrl + backslash
function up-one-level() {

	if [[ -n $BUFFER ]]; then
		return 0
	fi

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
	if [[ -n $BUFFER ]]; then
		zle forward-char
		return 0
	fi
	
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

	if [[ -n $BUFFER ]]; then
		zle backward-char
		return 0
	fi
	
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

export PIP_REQUIRE_VIRTUALENV=true
export PIP_RESPECT_VIRTUALENV=true
export WORKON_HOME=$HOME/.virtualenvs

command -v virtualenvwrapper.sh &>/dev/null
if [ $? ];
then
	source virtualenvwrapper.sh 2>/dev/null
fi
