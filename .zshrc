# Installation
# 1) git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
# 2) cd ~/.oh-my-zsh/custom/plugins && git clone git://github.com/zsh-users/zsh-syntax-highlighting.git
# 3) mkdir -p ~/.oh-my-zsh/plugins/docker
# 4) wget https://raw.githubusercontent.com/docker/docker/master/contrib/completion/zsh/_docker -O ~/.oh-my-zsh/plugins/docker/_docker
# 5) Download fzf from https://github.com/junegunn/fzf-bin/releases to ${PATH}
# 6) git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install

# hook for per-node customization
source ${HOME}/.zshrc.cust

# enable zinit
# note: how to update zinit and plugins:
#     - update zinit
#           zinit self-update
#     - update plugins
#           zinit update --parallel
source ~/.zinit/zinit.zsh

zinit load urbainvaes/fzf-marks
# `zsh-syntax-highlighting' should be the last imported one
zinit load zsh-users/zsh-syntax-highlighting

# enable auto completion functions
autoload -Uz compinit && compinit
# enable completion settings ...
#     - case-insensitive
#     - substring
zstyle ':completion:*' matcher-list 'r:|?=**' \
                                    'm:{a-z}={A-Za-z}'
#  tab-completion: sort filename by modification date
zstyle ':completion:*' file-sort modification

unsetopt AUTO_NAME_DIRS
autoload -U zmv

###################
# DISPLAY SETTINGS
###################

# for tmux compatibility
export TERM='xterm-256color'

## prompt format
# example:
# [19:03:33] username@hostname:~/curr/path$
export PS1=''
# starts boldface
export PS1=${PS1}'%B'
# part: [19:03:33]
export PS1=${PS1}'%F{252}[%f%F{208}%D{%H:%M:%S}%f%F{252}]%f '
# part: username
export PS1=${PS1}'%F{118}%n%f'
# part: @
export PS1=${PS1}'%F{252}@%f'
# part: hostname
export PS1=${PS1}'%F{135}%m%f'
# part: ':'
export PS1=${PS1}'%F{252}:%f'
# part: ~/curr/path
export PS1=${PS1}'%F{81}%~%f'
# part: $/# prompt (colored red when error code is returned)
export PS1=${PS1}'%(?.%F{252}.%F{161})%(!.#.$)%f '
# ends boldface
export PS1=${PS1}'%b'
## end prompt format

## i18n settings
export LANG='en_US.UTF-8'
export LANGUAGE='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# zsh syntax highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
source "${HOME}/.zshsyntaxcolors"

eval `dircolors ${HOME}/.dircolors`

export LESS_TERMCAP_md=$'\e[01;38;5;118m'    # begin bold
export LESS_TERMCAP_mb=$'\e[01;31m'          # begin blinking
export LESS_TERMCAP_me=$'\e[0m'              # end mode
export LESS_TERMCAP_so=$'\e[48;5;161;246m'   # begin standout-mode - info box
export LESS_TERMCAP_se=$'\e[0m'              # end standout-mode
export LESS_TERMCAP_us=$'\e[04;38;5;135m'    # begin underline
export LESS_TERMCAP_ue=$'\e[0m'              # end underline

### Terminal settings
export HISTFILE="${HOME}/.history"
export HISTSIZE=2000
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
# make history accessible in other tmux tab immediately
setopt share_history
# don't keep history for commands starting with a space
export HISTCONTROL=ignorespace
setopt hist_ignore_space

export EDITOR='vim -u ~/.vimrc.light'

stty -ixon
unset IGNOREEOF

alias e='emacs -nw'
# always open multiple files with tabs
alias vim='TERM=screen-256color vim -p'
alias v='vim'
alias irssi='TERM=screen irssi'
alias mutt='TERM=screen-256color mutt'

# tig: faster loading covers more use cases
alias  tig='TERM=screen-256color TIGRC_USER=${HOME}/.tigrc.light tig'
alias ttig='TERM=screen-256color tiig'

# ls -p: `/' postfix for for directories
alias ls='\ls -p --color=auto'
alias ll='\ls -p --color=auto -lh'

# `which' is useless without listing all possible match with
# all those aliases
alias which='which -a'

# force not to skip hidden/gitignore file
alias fd='\fd --no-ignore --hidden'
alias ag='\ag --all-types --hidden'

# remove deprecated `GREP_OPTIONS'
unset GREP_OPTIONS

alias cp='rsync -avh -P'
alias scp='rsync -avhz'

alias builddb='ctags -R && cscope -Rkbq && (find . -name "*.h" -exec echo "-include {}" \; > .clang_complete)'

alias df='\df -h'
alias today='date +%Y%m%d'

alias beep='/bin/echo -e "\a"'

# skip annoying version info on gdb startup
alias gdb='gdb --quiet'

# suppress the annoying confirm prompt on exit
alias ipython='ipython --no-confirm-exit'

# Git aliases
alias  gs='git status'
alias gst='gs'
alias  gb='git branch'
alias gbr='git branch --remote'

# Zsh

# don't enable vi-mode, as it breaks a lot of useful keybindings
# bindkey -v
# use emacs key-bindings instead
bindkey -e

# by default zsh chomps the padding space, inserted as you
# use tab-completion, when you type `|', `&', ` ', `\n', or `\t'
# (enumerated with variable ZLE_REMOVE_SUFFIX_CHARS).
# to reproduce this, you could try the following procedure:
#     - run `touch temp_file`
#     - type `ls temp_f`
#     - type tab
#     - type `|'
# see how annoying it is?
# this command excludes `|' and `&' from this behavior.
export ZLE_SPACE_SUFFIX_CHARS=$'&|'

# make forward-kill-word/backward-kill-word stop
# at '/', '[', '-', and so on ...
# original value: $WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
export WORDCHARS='_'

# Cheatsheet for caret symbols
# ^: ctrl
# ^[: alt
# or just use M-x `describe-key-briefly'

# import my helper functions
[ -f ~/.zsh_functions ] && source ~/.zsh_functions

# override default ctrl-k/ctrl-u behavior
bindkey "^k" kill-line
bindkey "^u" backward-kill-line

# bind to tab
bindkey '^I' expand-or-complete-or-list-files
# bind to ctrl + backslash
bindkey '^\\' dir-go-up-one-level
# bind to shift + tab
bindkey '^[[Z' completion-from-tmux-buffer
# bind to meta + x
bindkey '^[x' execute-named-cmd-menu

# bind to ctrl + F
bindkey '^F' forward
# bind to ctrl + B
bindkey '^B' backward

bindkey '^W'   backward-kill-arg
bindkey '^[^h' backward-kill-word

bindkey '^G' quit-history-search

# FZF
export FZF_DEFAULT_OPTS='--no-sort --reverse --exact'

export FZF_ALT_C_COMMAND="command find -L ${FZF_BOOKMARK}            \
			  \\( -maxdepth 3 -path '*/\\.*' \\) -prune  \
			  -o -type d -print 2> /dev/null | sed 1d"

export FZF_CTRL_T_COMMAND="command find -L ${FZF_BOOKMARK}           \
			   \\( -maxdepth 3 -path '*/\\.*' \\) -prune \
			   -o -type f -print                         \
			   -o -type d -print                         \
			   -o -type l -print 2> /dev/null | sed 1d"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# move away fzf's keybinding
bindkey '^[^R' fzf-history-widget
bindkey '^[P'  fzf-file-widget
bindkey '^[^P' fzf-cd-widget

# overwrite ctrl-r/s with more generic history search functions
# XXX: don't move this before loading `.fzf.zsh', as it overwrite
#      history search functions
bindkey '^R' history-incremental-pattern-search-backward
bindkey '^S' history-incremental-pattern-search-forward
