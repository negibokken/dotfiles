#!/bin/bash
ln -s ~/dotfiles/_zshrc ~/.zshrc
ln -s ~/dotfiles/_zshrc.local ~/.zshrc.local
ln -s ~/dotfiles/_vimrc ~/.vimrc
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_gitconfig ~/.gitconfig
if ! [[ -e ~/.config/nvim ]]; then
  mkdir ~/.config/nvim
fi
ln -s ~/dotfiles/_nvimrc ~/.config/nvim/init.vim

if [[ -e ~/.vim/colors ]]; then
  mkdir -p ~/.vim/colors
fi
if ! [[ -e ~/.vim/colors/hybrid.vim ]]; then
  wget https://raw.githubusercontent.com/w0ng/vim-hybrid/master/colors/hybrid.vim -O ~/.vim/colors/hybrid.vim
fi
