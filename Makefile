HOME_CONFIG := $(HOME)/.config

.PHONY: init
init: ## Sets up symlink for user and root .vimrc for vim and neovim.
	ln -snf "$(HOME)/.vim/vimrc" "$(HOME)/.vimrc" # Copy vimrc
	mkdir -p "$(HOME_CONFIG)" 
	ln -snf "$(HOME)/.vim" "$(HOME_CONFIG)/nvim"
	ln -snf "$(HOME)/.vimrc" "$(HOME_CONFIG)/nvim/init.vim"
	make update

.PHONY: update
update: update-repo update-submodules

.PHONY: update-repo
update-repo: ## Updates from cblanc/.vim
	git pull origin master

.PHONY: update-submodules
update-submodules: ## Updates git submodules
	git submodule update --init --recursive
	git submodule foreach git pull --recurse-submodules origin master
