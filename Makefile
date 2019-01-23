.DEFAULT_GOAL := help

HOME_CONFIG := $(HOME)/.config

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

## Setup vim on system
.PHONY: init
init: ## Sets up symlink for user and root .vimrc for vim and neovim.
	ln -snf "$(HOME)/.vim/vimrc" "$(HOME)/.vimrc" # Copy vimrc
	mkdir -p "$(HOME_CONFIG)" 
	ln -snf "$(HOME)/.vim" "$(HOME_CONFIG)/nvim"
	ln -snf "$(HOME)/.vimrc" "$(HOME_CONFIG)/nvim/init.vim"
	make update

## Update settings repo and submodules
.PHONY: update
update: update-repo update-submodules

## Updates from cblanc/.vim
.PHONY: update-repo
update-repo: 
	git pull origin master

## Update submodules
.PHONY: update-submodules
update-submodules: ## Updates git submodules
	git submodule update --init --recursive
	git submodule foreach git pull --recurse-submodules origin master

