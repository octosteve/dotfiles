#!/usr/bin/env zsh
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# if debian based
if [ -f /etc/debian_version ]; then
  sudo apt-get update

  sudo apt install -y direnv zsh build-essential ripgrep ruby-dev exuberant-ctags

	sudo chsh -s "$(which zsh)" "$(whoami)"

  wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
  sudo apt install ./nvim-linux64.deb
fi

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1

mkdir -p ~/.config/nvim
ln -fs $SCRIPT_DIR/nvim_configs/* ~/.config/nvim/

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

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

nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
