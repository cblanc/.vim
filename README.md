# .vim Files

## Setup

```bash
git clone https://github.com/cblanc/.vim
make
```

## Update

```
make update
```

## Adding a submodule

```bash
git submodule add git@github.com:author/module bundle/module
```

### Notes

#### Neovim

Following links need to exist

```bash
# Symlink vim config to neovim config directory 
~/.config/nvim -> ~/.vim

# Symlink neovims init file to vimrc
~/.vim/init.vim -> ~/vimrc
```

