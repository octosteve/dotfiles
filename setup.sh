#!/usr/bin/env zsh

set -ex

# Function to install Homebrew if not installed
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

# Function to install packages using Homebrew
install_homebrew_packages() {
  echo "Installing packages with Homebrew..."
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
  if [ "$SHELL" != "/usr/local/bin/zsh" ] && [ "$SHELL" != "/bin/zsh" ]; then
    echo "Changing shell to zsh..."
    local zsh_path=""
    if [ -x /usr/local/bin/zsh ]; then
      zsh_path="/usr/local/bin/zsh"
    elif [ -x /bin/zsh ]; then
      zsh_path="/bin/zsh"
    else
      echo "Error: Unable to find a valid zsh executable in known locations. Please install zsh manually and set it as your default shell."
      exit 1
    fi
    chsh -s "$zsh_path" "$(whoami)"
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
  local asdf_plugins=("nodejs" "ruby" "erlang" "elixir" "golang")
  for plugin in "${asdf_plugins[@]}"; do
    asdf plugin add "$plugin" "https://github.com/asdf-vm/asdf-$plugin.git"
    asdf install "$plugin" latest
    asdf global "$plugin" latest
  done
}

# Function to set up configuration files
setup_config_files() {
  echo "Linking rc files Files"
  wget -O .zshrc https://git.grml.org/f/grml-etc-core/etc/zsh/zshrc
  wget -O .tmux.conf https://git.grml.org/f/grml-etc-core/etc/tmux.conf
  ln -fs "$SCRIPT_DIR/tmux.conf.local" ~/.tmux.conf.local
  ln -fs "$SCRIPT_DIR/zshrc.local" ~/.zshrc.local
  mkdir -p ~/.config/nvim
  ln -fs "$SCRIPT_DIR/nvim_configs/*" ~/.config/nvim/
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

# Setup bin dir for local binaries
mkdir -p ~/bin

# Install Neovim using Homebrew
echo "Installing Neovim using Homebrew..."
brew install neovim

# Perform Neovim setup
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
