#!/bin/bash
ln -s ~/dotfiles/_zshrc ~/.zshrc
ln -s ~/dotfiles/_vimrc ~/.vimrc
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_gitconfig ~/.gitconfig

if [[ -e ~/.vim/colors ]]; then
  mkdir -p ~/.vim/colors
fi
wget https://raw.githubusercontent.com/w0ng/vim-hybrid/master/colors/hybrid.vim -O ~/.vim/colors/hybrid.vim
