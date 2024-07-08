#!/usr/bin/env zsh

set -ex

# Function to install Homebrew if not installed
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

# Function to install packages using Homebrew
install_homebrew_packages() {
  echo "Installing packages with Homebrew..."

  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ "$(uname -s)" == "Linux" ]]; then
    # Linux
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  else
    echo "Unsupported operating system"
    exit 1
  fi

  brew install direnv zsh ripgrep ctags tmux neovim jq gnupg libyaml wget
}

# Function to install packages on Debian-based systems
install_debian_packages() {
  if [ -f /etc/debian_version ]; then
    sudo apt-get update
    sudo apt install -y build-essential ruby-dev
  fi
}

# Function to change the shell to zsh if not already
change_shell_to_zsh() {
  local zsh_path
  zsh_path=$(which zsh)

  if [ -z "$zsh_path" ]; then
    echo "Error: zsh not found in the system. Please install zsh and try again."
    exit 1
  fi

  if [ "$SHELL" != "$zsh_path" ]; then
    echo "Changing shell to zsh..."
    sudo chsh "$(id -un)" --shell "$zsh_path"
    echo "Shell changed to zsh. Please log out and log back in for the changes to take effect."
  else
    echo "Shell is already set to zsh."
  fi
}

# Function to install asdf and its plugins
install_asdf() {
  # Determine the latest version of asdf
  local LATEST_ASDF_VERSION
  LATEST_ASDF_VERSION=$(curl -s https://api.github.com/repos/asdf-vm/asdf/releases/latest | jq -r '.tag_name')

  # Install asdf with the latest version
  echo "Installing asdf (latest version: $LATEST_ASDF_VERSION)"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "$LATEST_ASDF_VERSION"
  source $HOME/.asdf/asdf.sh

  # Install plugins and languages (latest versions) using asdf
  plugins=("github-cli" "nodejs" "ruby" "elixir" "erlang" "golang")
  for plugin in "${plugins[@]}"; do
    asdf plugin-add "$plugin" || true
    # the "|| true" ignore errors if a certain plugin already exists
    asdf install "$plugin" latest
    asdf global "$plugin" latest
  done
  echo "Installation complete."
}

# Function to set up configuration files
setup_config_files() {
  echo "Linking rc files Files"
  wget -O ~/.zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
  wget -O ~/.tmux.conf https://git.grml.org/f/grml-etc-core/etc/tmux.conf
  ln -fs "$SCRIPT_DIR/tmux.conf.local" ~/.tmux.conf.local
  ln -fs "$SCRIPT_DIR/zshrc.local" ~/.zshrc.local
  mkdir -p ~/.config/nvim
  # Iterate over each item in the nvim_configs directory
  for item in "$SCRIPT_DIR/nvim_configs/"*; do
    ln -fs "$item" ~/.config/nvim/
  done
}

# Function to install FZF
install_fzf() {
  echo "Installing FZF"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
}

# Function to configure Git settings
configure_git() {
  git config --global user.name "Steven Nuñez"
  git config --global pull.rebase true
  git config --global core.editor "nvim"
  git config --global push.autoSetupRemote true
}

install_packer() {
  PACKER_DIR="${HOME}/.local/share/nvim/site/pack/packer/start/packer.nvim"
  if [ ! -d "$PACKER_DIR" ]; then
    echo "Installing packer.nvim..."
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$PACKER_DIR"
  fi
}

# Main script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
install_homebrew
install_homebrew_packages
install_debian_packages
change_shell_to_zsh
install_asdf
configure_git
setup_config_files
install_fzf
install_packer

# Setup bin dir for local binaries
mkdir -p ~/bin

# Perform Neovim setup
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
