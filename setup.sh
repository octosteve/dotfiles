#!/bin/bash
if env | grep -q ^CODESPACES=; then
  # You might not need this
  #  curl -sL https://deb.nodesource.com/setup_15.x | bash -
  sudo add-apt-repository ppa:cpick/hub

  sudo apt-get update

  sudo apt install -y direnv zsh hub build-essential nodejs python3 ripgrep ruby-dev fuse libfuse2 bat

	sudo chsh -s "$(which zsh)" "$(whoami)"

	# install latest neovim
	sudo modprobe fuse
	sudo groupadd fuse
	sudo usermod -a -G fuse "$(whoami)"
	wget https://github.com/github/copilot.vim/releases/download/neovim-nightlies/appimage.zip
	unzip appimage.zip
	sudo chmod u+x nvim.appimage
	sudo mv nvim.appimage /usr/local/bin/nvim

  pip3 install pynvim
fi

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

nvim +'PackUpdate' +qa

vim -Es -u $HOME/.vimrc -c "PackUpdate | qa"


ln -fs $(pwd)/tmux.conf ~/.tmux.conf
ln -fs $(pwd)/zshrc ~/.zshrc
ln -fs $(pwd)/zshrc.local ~/.zshrc.local

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Setup bin dir for local binaries
mkdir -p ~/bin
