#!/bin/bash
if env | grep -q ^CODESPACES=; then
  # You might not need this
  #  curl -sL https://deb.nodesource.com/setup_15.x | bash -
  sudo add-apt-repository ppa:cpick/hub

  sudo apt-get update

  sudo apt install -y direnv zsh hub build-essential nodejs python3 ripgrep ruby-dev

	sudo chsh -s "$(which zsh)" "$(whoami)"

	# install latest neovim
	wget https://github.com/github/copilot.vim/releases/download/neovim-nightlies/appimage.zip
	unzip appimage.zip

	sudo chmod u+x nvim.appimage
  ./nvim.appimage --appimage-extract
  ./squashfs-root/AppRun --version

  sudo mv squashfs-root /

  pip3 install pynvim
fi

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
mkdir -p ~/.config/nvim
ln -fs $(pwd)/neovimrc ~/.config/nvim/init.vim

mkdir -p ~/.vim
ln -fs $(pwd)/vimrc ~/.vim/vimrc

# Incase we're using regular vim
ln -fs $(pwd)/vimrc ~/.vimrc

# Install minpac
git clone https://github.com/k-takata/minpac.git \
    ~/.vim/pack/minpac/opt/minpac

git clone https://github.com/k-takata/minpac.git \
    ~/.config/nvim/pack/minpac/opt/minpac

ln -fs $(pwd)/tmux.conf ~/.tmux.conf
ln -fs $(pwd)/zshrc ~/.zshrc
ln -fs $(pwd)/zshrc.local ~/.zshrc.local

exec zsh

# Install NodeJS
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Setup bin dir for local binaries
mkdir -p ~/bin
ln -fs /squashfs-root/AppRun ~/bin/nvim

nvim --headless +PackUpdate +qa

vim -Es -u $HOME/.vimrc -c "PackUpdate | qa"
