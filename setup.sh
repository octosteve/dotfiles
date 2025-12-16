#!/usr/bin/env bash

set -e

# Function to install Homebrew if not installed
install_homebrew() {
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for this script
    if [[ "$(uname)" == "Darwin" ]]; then
      if [ -x "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [ -x "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
    elif [[ "$(uname -s)" == "Linux" ]]; then
      if [ -d /home/linuxbrew/.linuxbrew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      elif [ -d ~/.linuxbrew ]; then
        eval "$(~/.linuxbrew/bin/brew shellenv)"
      fi
    fi
  else
    echo "Homebrew is already installed."
  fi
}

# Function to install packages using Homebrew
install_homebrew_packages() {
  echo "Installing packages with Homebrew..."

  if [[ "$(uname)" == "Darwin" ]]; then
    # macOS
    if [ -x "/opt/homebrew/bin/brew" ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x "/usr/local/bin/brew" ]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  elif [[ "$(uname -s)" == "Linux" ]]; then
    # Linux
    if [ -d /home/linuxbrew/.linuxbrew ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d ~/.linuxbrew ]; then
      eval "$(~/.linuxbrew/bin/brew shellenv)"
    fi
  else
    echo "Unsupported operating system"
    exit 1
  fi

  # Install packages if brew is available
  if command -v brew &>/dev/null; then
    brew install direnv zsh ripgrep ctags tmux neovim jq gnupg libyaml wget
  else
    echo "Warning: Homebrew not found. Skipping Homebrew package installation."
  fi
}

# Function to install packages on Debian-based systems
install_debian_packages() {
  if [ -f /etc/debian_version ]; then
    echo "Detected Debian-based system. Installing essential packages..."
    if command -v apt-get &>/dev/null; then
      sudo apt-get update
      sudo apt-get install -y build-essential ruby-dev curl git
    fi
  fi
}

# Function to change the shell to zsh if not already
change_shell_to_zsh() {
  # Skip in non-interactive environments like Codespaces or CI
  if [ -n "$CODESPACES" ] || [ -n "$CI" ]; then
    echo "Skipping shell change in non-interactive environment (Codespaces/CI)."
    return
  fi

  local zsh_path
  zsh_path=$(which zsh)

  if [ -z "$zsh_path" ]; then
    echo "Error: zsh not found in the system. Please install zsh and try again."
    exit 1
  fi

  if [ "$SHELL" != "$zsh_path" ]; then
    echo "Changing shell to zsh..."
    # Use chsh without sudo for better compatibility
    if command -v chsh &>/dev/null; then
      chsh -s "$zsh_path" || {
        echo "Note: Could not change shell automatically. You can change it manually with:"
        echo "  chsh -s $zsh_path"
      }
    else
      echo "Note: chsh command not available. You can change your shell manually."
    fi
    echo "Shell changed to zsh. Please log out and log back in for the changes to take effect."
  else
    echo "Shell is already set to zsh."
  fi
}

# Function to install asdf and its plugins
install_asdf() {
  if [ ! -d "$HOME/.asdf" ]; then
    echo "Installing asdf..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
  fi
  
  # Source asdf
  export ASDF_DIR="${ASDF_DATA_DIR:-$HOME/.asdf}"
  . "$HOME/.asdf/asdf.sh"
  
  # Install plugins and languages (latest versions) using asdf
  plugins=("github-cli" "nodejs" "ruby" "elixir" "erlang" "golang")
  for plugin in "${plugins[@]}"; do
    # the "|| true" ignore errors if a certain plugin already exists
    asdf plugin add "$plugin" 2>/dev/null || true
    asdf install "$plugin" latest || true
    asdf global "$plugin" latest || true
  done
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"

  echo "asdf installation complete."
}

# Function to set up configuration files
setup_config_files() {
  echo "Linking rc files Files"
  if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.bak
  fi
  if [ -f ~/.tmux.conf ]; then
    cp ~/.tmux.conf ~/.tmux.conf.bak
  fi
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
  if [ -d ~/.fzf ]; then
    echo "FZF is already installed."
    return
  fi
  echo "Installing FZF"
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
}

# Function to configure Git settings
configure_git() {
  # Only set user.name if not already configured
  if [ -z "$(git config --global user.name)" ]; then
    echo "Git user.name not set. Please configure it manually with:"
    echo "  git config --global user.name \"Your Name\""
  fi
  
  # Only set user.email if not already configured
  if [ -z "$(git config --global user.email)" ]; then
    echo "Git user.email not set. Please configure it manually with:"
    echo "  git config --global user.email \"your.email@example.com\""
  fi
  
  git config --global pull.rebase true
  git config --global core.editor "nvim"
  git config --global push.autoSetupRemote true
}

install_lazy() {
  LAZY_DIR="${HOME}/.local/share/nvim/lazy/lazy.nvim"
  if [ ! -d "$LAZY_DIR" ]; then
    echo "Installing lazy.nvim..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_DIR"
  fi
}

install_tpm() {
  TPM_DIR="${HOME}/.tmux/plugins/tpm"
  if [ ! -d "$TPM_DIR" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
  fi
}

# Main script
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-$0}")" &>/dev/null && pwd)"

echo "Starting dotfiles setup..."
echo "Detected OS: $(uname -s)"
[ -n "$CODESPACES" ] && echo "Running in GitHub Codespaces"

install_homebrew
install_homebrew_packages
install_debian_packages
change_shell_to_zsh
install_asdf
configure_git
setup_config_files
install_fzf
install_lazy
install_tpm

# Setup bin dir for local binaries
mkdir -p ~/bin

# Perform Neovim setup with lazy.nvim
echo "Syncing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

echo ""
echo "Setup complete! Please restart your shell or run: source ~/.zshrc"
