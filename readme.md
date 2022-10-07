# Installation
# Vim
vim plug
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

fzf
```
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```
- Remember to run :PlugInstall


# Usage
## nvim + tmux cheatsheet
[markdown cheatsheet](https://www.markdownguide.org/cheat-sheet/)

## Misc
- nvim <Leader> key mapped to spacebar
- toggle between absolute and relative line numbers with <Leader>-r 
- close current buffer tab: <Leader>-c

## tmux
- custom mapping: C-b v which opens a 70-30 left-right split

## Navigation
- move between nvim and tmux panes with C-hjkl
- move between nvim buffers with C-h/l
- open NvimTree with <Leader>-e
- open Telescope file finder with <Leader>-f
    - enter to open
    - C-x for top-bottom split (new buffer opens below)
    - C-v for left-right split (new buffer opens on the right)

## Comment
- toggle current line (single or block): gcc, gbc
- toggle visual mode selection (single or block): gc, gb

## LSP Things
- gD: go to declaration
- gd: go to definition
- K: hover
- gi: to to implementation
- gr: go to references
- gl: show line diagnostics
