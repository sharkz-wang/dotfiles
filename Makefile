
define __install
	@echo installing $1 ...
	@test -h ${HOME}/$1 || ln -s ${PWD}/$1 ${HOME}/$1
endef

all:
	$(call __install,.zshrc)
	$(call __install,.zshrc.cust)
	$(call __install,.zsh_functions)
	$(call __install,.zshsyntaxcolors)
	$(call __install,.oh-my-zsh)
	$(call __install,.dircolors)

#	$(call __install,.bashrc)

	$(call __install,.vimrc)
	$(call __install,.vimrc.light)

	$(call __install,.muttrc)
	$(call __install,.irssi)

	$(call __install,.gdbinit)
	$(call __install,.gdbinit.d)
	$(call __install,.gdb_dashboard)

	$(call __install,.tmux.conf)
	$(call __install,.tmux.conf.clean)

	$(call __install,.tigrc)
	$(call __install,.tigrc.light)

	$(call __install,.gitconfig)
	$(call __install,.gitignore_global)
