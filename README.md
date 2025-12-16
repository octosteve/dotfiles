# Dotfiles

Personal development environment configuration for macOS, Ubuntu, and GitHub Codespaces.

## Quick Start

```bash
git clone https://github.com/octosteve/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

## What's Included

### Shell Configuration
- **zsh** as the default shell with [grml-zsh-config](https://grml.org/zsh/)
- Custom `.zshrc.local` with aliases, functions, and environment setup
- **tmux** with custom configuration and [TPM](https://github.com/tmux-plugins/tpm) plugin manager
- **direnv** for directory-specific environment variables

### Development Tools
- **Homebrew** package manager (macOS and Linux)
- **asdf** version manager for multiple languages (installed via Homebrew, go install, or pre-compiled binary):
  - Node.js
  - Ruby
  - Elixir/Erlang
  - Golang
  - GitHub CLI
- **FZF** fuzzy finder for command-line
- **Neovim** with [lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager

### Neovim Plugins
- Telescope (fuzzy finder)
- Treesitter (syntax highlighting)
- LSP support with Mason
- GitHub Copilot
- Ruby/Rails support
- Git integration (fugitive, rhubarb)
- And more...

## Supported Platforms

- ✅ **macOS** (Intel and Apple Silicon)
- ✅ **Ubuntu/Debian** Linux
- ✅ **GitHub Codespaces**

The setup script automatically detects your environment and adapts accordingly.

## Features

### Environment Detection
The setup script detects and handles special environments:
- **GitHub Codespaces**: Skips shell changes and tmux auto-start
- **CI environments**: Skips interactive operations
- **macOS vs Linux**: Uses appropriate Homebrew paths and package managers

### Idempotency
The script is safe to run multiple times. It checks for existing installations and only installs what's missing.

### Error Handling
- Clear error messages for failed operations
- Non-fatal warnings for optional components
- Continues on recoverable errors

## Manual Configuration

After running the setup script, you may want to configure:

1. **Git identity** (if not already set):
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

2. **Tmux plugins**: Press `prefix + I` (default: `Ctrl-b + I`) in tmux to install plugins

3. **Shell**: Restart your terminal or run `source ~/.zshrc`

## Customization

### Adding Custom Aliases or Functions
Edit `zshrc.local` to add your own aliases, functions, or environment variables.

### Adding Neovim Plugins
Edit `nvim_configs/lua/octosteve/lazy.lua` and add plugins to the setup array.

### Adding Tmux Plugins
Edit `tmux.conf.local` and add TPM plugins with `set -g @plugin 'plugin/name'`.

## Troubleshooting

### Homebrew not in PATH
If `brew` command is not found after installation, run:
```bash
# macOS
eval "$(/opt/homebrew/bin/brew shellenv)"  # Apple Silicon
# or
eval "$(/usr/local/bin/brew shellenv)"     # Intel

# Linux
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### Shell not changed
If your shell didn't change to zsh automatically, run:
```bash
chsh -s $(which zsh)
```

### Neovim plugins not loading
Run `:Lazy sync` inside Neovim to manually sync plugins.

## File Structure

```
.
├── setup.sh              # Main setup script
├── zshrc.local          # Custom zsh configuration
├── tmux.conf.local      # Custom tmux configuration
└── nvim_configs/        # Neovim configuration
    ├── init.lua
    ├── after/           # Plugin configurations
    └── lua/octosteve/   # Custom lua modules
        ├── lazy.lua     # Plugin definitions
        ├── remap.lua    # Key mappings
        ├── set.lua      # Vim settings
        └── functions.lua # Custom functions
```

## License

Personal dotfiles - feel free to fork and adapt for your own use.
