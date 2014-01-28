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
#antigen theme

# Tell antigen that you're done.
antigen apply

export TERM='xterm-256color'
export PS1='%{$fg_bold[green]%}%n%{$fg_bold[white]%}@%{$fg_bold[magenta]%}%m%{$fg_bold[white]%}:%{$fg_bold[cyan]%}%~%{$fg_bold[white]%}%(!.#.$) '
export PATH="${HOME}/script:${HOME}/bin:${PATH}"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${HOME}/lib"

export LANG='en_US.utf8'
export LC_CTYPE='en_US.utf8'

export EDITOR='vim'

stty -ixon
unset IGNOREEOF

alias ..='cd ..'
alias ...='cd ../..'

alias vim='TERM=screen-256color vim -p'

alias ls='ls --color=auto'
alias ll='ls -l'
alias grep='grep --color=auto'

alias irssi='TERM=screen irssi'

alias ding='/bin/echo -e "\a"'

eval `dircolors ${HOME}/.dircolors`

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# STYLES
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[default]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=magenta,bold'

# Aliases and functions
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'

# Commands and builtins
ZSH_HIGHLIGHT_STYLES[command]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[precommand]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[hashed-command]="fg=green,bold"
ZSH_HIGHLIGHT_STYLES[builtin]="fg=green,bold"

# Paths
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,bold'

# Globbing
ZSH_HIGHLIGHT_STYLES[globbing]='fg=yellow,bold'

# Options and arguments
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=magenta,bold'

ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]="fg=yellow,bold"
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]="fg=yellow,bold"

ZSH_HIGHLIGHT_STYLES[bracket-level-1]="fg=magenta,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-2]="fg=magenta,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-3]="fg=magenta,bold"
ZSH_HIGHLIGHT_STYLES[bracket-level-4]="fg=magenta,bold"

# PATTERNS
# rm -rf
ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')

# Sudo
ZSH_HIGHLIGHT_PATTERNS+=('sudo' 'fg=white,bold,bg=red')

tmuxrc.sh
