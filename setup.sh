#!/bin/bash
if [[ -z "${CODESPACES}" ]]; then
  curl -sL https://deb.nodesource.com/setup_15.x | bash -
  add-apt-repository ppa:cpick/hub

  apt-get update

  apt install -y neovim direnv zsh hub build-essential nodejs python3

  chsh -s /usr/bin/zsh

  git clone https://github.com/vim/vim.git /tmp/vim
  cd /tmp/vim/src
  make
  make install
  
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
  chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  ./squashfs-root/AppRun --version

  mv squashfs-root /
  pip3 install pynvim
fi

mkdir -p ~/.config/nvimln -s $(pwd)/neovimrc ~/.config/nvim/init.vim
mkdir -p ~/.vim
ln -s $(pwd)/vimrc ~/.vim/vimrc

# Incase we're using regular vim
ln -s $(pwd)/vimrc ~/.vimrc# Install minpac
git clone https://github.com/k-takata/minpac.git \
    ~/.vim/pack/minpac/opt/minpac

git clone https://github.com/k-takata/minpac.git \
    ~/.config/nvim/pack/minpac/opt/minpac
ln -s $(pwd)/tmux.conf ~/.tmux.conf
ln -s $(pwd)/zshrc ~/.zshrc
ln -s $(pwd)/zshrc.local ~/.zshrc.local

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Setup bin dir for local binaries
mkdir -p ~/bin
ln -s /squashfs-root/AppRun ~/bin/nvim
