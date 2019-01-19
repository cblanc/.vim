# .vim Files

## Setup

```bash
git clone https://github.com/cblanc/.vim.git ~/.vim
cd ~/.vim && make init
```

## Update

```
make update
```

## Add Submodule

```bash
git submodule add https://github.com/<author>/<module>.git bundle/<module>
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

