#!/bin/bash
ln -s ~/dotfiles/_zshrc ~/.zshrc
ln -s ~/dotfiles/_zshrc.local ~/.zshrc.local
ln -s ~/dotfiles/_vimrc ~/.vimrc
ln -s ~/dotfiles/_tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/_gitconfig ~/.gitconfig
if ! [[ -e ~/.config/nvim ]]; then
  mkdir -p ~/.config/nvim
fi
ln -s ~/dotfiles/_nvimrc ~/.config/nvim/init.vim

if [[ -e ~/.vim/colors ]]; then
  mkdir -p ~/.vim/colors
fi

if ! [[ -e ~/.vim/colors/hybrid.vim ]]; then
  mkdir -p ~/.vim/colors
  wget https://raw.githubusercontent.com/w0ng/vim-hybrid/master/colors/hybrid.vim -O ~/.vim/colors/hybrid.vim
fi

if ! [[ -e ~/.vim/after ]]; then
    mkdir -p ~/.vim/after
    ln -s ~/dotfiles/vimconf/ftplugin ~/.vim/after/
fi

if ! [[ -e ~/.gitconfig.local ]]; then
    printf "\e[31mPlease fill out ~/.gitconfig.local\e[m\n"
    printf "[user]\n    name = \n    email = \n" > ~/.gitconfig.local
fi

# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
