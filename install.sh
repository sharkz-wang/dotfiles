
function __install () {
	echo Installing $1 ...
	test -h ${HOME}/$1 || ln -s ${PWD}/$1 ${HOME}/$1

	test "$?" != '0' && (echo 'installation failed, aborting ...'; exit -1)
}

__install .zshrc
__install .zshrc.cust
__install .zsh_functions
__install .zshsyntaxcolors
__install .zinit

__install .fzf.zsh
__install .dircolors

#       does `~/.zinit' exist as a directory?
# if [ ! -d ~/.zinit ]
# then
# 	mkdir ${HOME}/.zinit
# 	git clone https://github.com/zdharma/zinit.git ${HOME}/.zinit/bin
# 	# make zinit runnable even when current zsh session does
# 	# not equipped with zinit
# 	zsh --interactive -c 'zinit self-update'
# 	zsh --interactive -c 'zinit update --parallel'
# fi

__install .bashrc

__install script

__install .vimrc
__install .vimrc.light

__install .muttrc
__install .irssi

__install .gdbinit
__install .gdbinit.d
__install .gdb_dashboard

__install .tmux.conf
__install .tmux.conf.clean

__install .tigrc
__install .tigrc.light

__install .gitconfig
__install .gitignore_global

echo 'Installation done, exit ...'

exit 0
