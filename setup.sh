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

# Function to change the shell to zsh
change_shell_to_zsh() {
  if [ -n "$CODESPACES" ] || [ -n "$CI" ]; then
    echo "Skipping shell change in non-interactive environment."
    return
  fi

  local zsh_path
  zsh_path=$(which zsh)

  if [ -z "$zsh_path" ]; then
    echo "Error: zsh not found. Please install zsh and try again."
    exit 1
  fi

  if [ "$SHELL" != "$zsh_path" ]; then
    echo "Changing shell to zsh..."
    if command -v chsh &>/dev/null; then
      chsh -s "$zsh_path" "$(whoami)" || {
        echo "Note: Could not change shell automatically. You can change it manually with:"
        echo "  chsh -s $zsh_path"
      }
    else
      echo "Note: chsh command not available."
    fi
    echo "Shell changed. Please log out and log back in for changes to take effect."
  else
    echo "Shell is already set to zsh."
  fi
}

# Function to install asdf and its plugins
install_asdf() {
  if ! command -v asdf &>/dev/null; then
    echo "Installing asdf..."
    
    if command -v brew &>/dev/null; then
      brew install asdf
    elif command -v go &>/dev/null; then
      echo "Installing asdf via go install..."
      go install github.com/asdf-vm/asdf/cmd/asdf@latest
      export PATH="${GOPATH:-$HOME/go}/bin:$PATH"
    else
      echo "Downloading pre-compiled asdf binary..."
      ASDF_VERSION="v0.18.0"
      ARCH="$(uname -m)"
      OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
      
      case "$ARCH" in
        x86_64) ARCH="amd64" ;;
        aarch64|arm64) ARCH="arm64" ;;
      esac
      
      mkdir -p "$HOME/.local/bin"
      DOWNLOAD_URL="https://github.com/asdf-vm/asdf/releases/download/${ASDF_VERSION}/asdf_${ASDF_VERSION}_${OS}_${ARCH}.tar.gz"
      echo "Downloading from: $DOWNLOAD_URL"
      
      if curl -fsSL "$DOWNLOAD_URL" | tar -xz -C "$HOME/.local/bin" asdf 2>/dev/null; then
        chmod +x "$HOME/.local/bin/asdf"
        export PATH="$HOME/.local/bin:$PATH"
        echo "asdf binary installed to ~/.local/bin"
      else
        echo "Error: Failed to download asdf binary. Please install manually."
        return 1
      fi
    fi
  else
    echo "asdf is already installed."
  fi
  
  if command -v brew &>/dev/null && command -v asdf &>/dev/null; then
    if [ -f "$(brew --prefix asdf)/libexec/asdf.sh" ]; then
      . "$(brew --prefix asdf)/libexec/asdf.sh"
    fi
  elif ! command -v asdf &>/dev/null; then
    echo "Error: asdf installation failed or not in PATH"
    return 1
  fi
  
  # Install plugins and languages using asdf
  plugins=("github-cli" "nodejs" "ruby" "elixir" "erlang" "golang")
  for plugin in "${plugins[@]}"; do
    echo "Processing asdf plugin: $plugin"
    if ! asdf plugin list | grep -q "^${plugin}$"; then
      asdf plugin add "$plugin" || echo "Warning: Could not add plugin $plugin"
    fi
    if asdf install "$plugin" latest; then
      asdf global "$plugin" latest
    else
      echo "Warning: Could not install $plugin latest version"
    fi
  done
  mkdir -p "${ASDF_DATA_DIR:-$HOME/.asdf}/completions"
  asdf completion zsh > "${ASDF_DATA_DIR:-$HOME/.asdf}/completions/_asdf"

  echo "asdf installation complete."
}

# Function to set up configuration files
setup_config_files() {
  echo "Linking configuration files"
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
  if [ -z "$(git config --global user.name)" ]; then
    echo "Git user.name not set. Configure with:"
    echo "  git config --global user.name \"Your Name\""
  fi
  
  if [ -z "$(git config --global user.email)" ]; then
    echo "Git user.email not set. Configure with:"
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
    echo "Installing TPM..."
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

mkdir -p ~/bin

echo "Syncing Neovim plugins..."
nvim --headless "+Lazy! sync" +qa

echo ""
echo "Setup complete! Restart your shell or run: source ~/.zshrc"
