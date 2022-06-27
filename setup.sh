#!/usr/bin/env zsh
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

if env | grep -q ^CODESPACES=; then
  sudo add-apt-repository ppa:cpick/hub

  sudo apt-get update

  sudo apt install -y direnv zsh hub build-essential nodejs python3 ripgrep ruby-dev

	sudo chsh -s "$(which zsh)" "$(whoami)"

  wget https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.deb
  sudo apt install ./nvim-linux64.deb

  pip3 install pynvim
fi

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.1
mkdir -p ~/.config/nvim
ln -fs $SCRIPT_DIR/neovimrc ~/.config/nvim/init.vim

mkdir -p ~/.vim
ln -fs $SCRIPT_DIR/vimrc ~/.vim/vimrc

# Incase we're using regular vim
ln -fs $SCRIPT_DIR/vimrc ~/.vimrc

# Install minpac
git clone https://github.com/k-takata/minpac.git \
    ~/.vim/pack/minpac/opt/minpac

git clone https://github.com/k-takata/minpac.git \
    ~/.config/nvim/pack/minpac/opt/minpac

echo "Linking rc files Files"
ln -fs $SCRIPT_DIR/tmux.conf ~/.tmux.conf
ln -fs $SCRIPT_DIR/zshrc ~/.zshrc
ln -fs $SCRIPT_DIR/zshrc.local ~/.zshrc.local

echo "Linking rc files Files"

# Install NodeJS
echo "Installing NodeJS"
zsh -c ". ~/.zshrc && \
        asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git && \
        asdf install nodejs latest && \
        asdf global nodejs latest
       "

# Install Ruby
echo "Installing Ruby"
zsh -c ". ~/.zshrc && \
        asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git && \
        asdf install ruby latest && \
        asdf global ruby latest
       "

# Install fzf
echo "Installing FZF"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Setup bin dir for local binaries
mkdir -p ~/bin

echo "Configuring NVIM"
zsh -c ". ~/.zshrc && nvim --headless +PackUpdate +qa"

echo "Configuring VIM"
zsh -c ". ~/.zshrc && vim -Es -u $HOME/.vimrc -c \"call minpac#update(\'\', {\'do\': \'quit\'})\" +qa"
