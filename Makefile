.DEFAULT_GOAL := help

HOME_CONFIG := $(HOME)/.config

## Setup vim on system
.PHONY: init
init: ## Sets up symlink for user and root .vimrc for vim and neovim.
	ln -snf "$(HOME)/.vim/vimrc" "$(HOME)/.vimrc" # Copy vimrc
	mkdir -p "$(HOME_CONFIG)" 
	ln -snf "$(HOME)/.vim" "$(HOME_CONFIG)/nvim"
	ln -snf "$(HOME)/.vimrc" "$(HOME_CONFIG)/nvim/init.vim"
	make plugins-init

## Updates .vim settings and plugins from cblanc/.vim
.PHONY: update
update: 
	git fetch
	git merge --ff-only origin/master

## -- Plugin Methods --

## Update vim plugins
.PHONY: plugins-update
plugins-update: ## Git pulls over every submodule in bundle
	git submodule foreach git pull --recurse-submodules origin master
	make compile-vimproc

## Download vim plugins
.PHONY: plugins-init
plugins-init:
	git submodule init
	git submodule update --recursive --jobs=8
	make compile-vimproc
	make install-youcompleteme

## -- Misc --

## Compile bundle/vimproc.vim
.PHONY: compile-vimproc
compile-vimproc:
	cd "${CURDIR}/bundle/vimproc.vim" && make

## Install YouCompleteMe
## - Adds rust (rls) support by default
## - Adds TypeScript (tsserver) support by default
.PHONY: install-youcompleteme
install-youcompleteme:
	cd "${CURDIR}/bundle/YouCompleteMe" && python3 install.py --rust-completer --ts-completer

## Help message
.PHONY: help
help:
	@printf "Usage\n";

	@awk '{ \
			if ($$0 ~ /^.PHONY: [a-zA-Z\-\_0-9]+$$/) { \
				helpCommand = substr($$0, index($$0, ":") + 2); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^[a-zA-Z\-\_0-9.]+:/) { \
				helpCommand = substr($$0, 0, index($$0, ":")); \
				if (helpMessage) { \
					printf "\033[36m%-20s\033[0m %s\n", \
						helpCommand, helpMessage; \
					helpMessage = ""; \
				} \
			} else if ($$0 ~ /^##/) { \
				if (helpMessage) { \
					helpMessage = helpMessage"\n                     "substr($$0, 3); \
				} else { \
					helpMessage = substr($$0, 3); \
				} \
			} else { \
				if (helpMessage) { \
					print "\n                     "helpMessage"\n" \
				} \
				helpMessage = ""; \
			} \
		}' \
		$(MAKEFILE_LIST)
