#!/bin/bash

# ----------------------------------------------------------------------------
#  Modern Dotfiles Bootstrap Script
# ----------------------------------------------------------------------------

set -e

echo "🚀 Starting Dotfiles Modernization..."

# 1. Detect platform and install core tooling
OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
    # Install Homebrew on macOS if missing
    if ! command -v brew &>/dev/null; then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "📦 Installing core packages (Homebrew)..."
    brew install stow git vim tmux fzf ag coreutils
elif command -v apt-get &>/dev/null; then
    echo "📦 Installing core packages (apt)..."
    sudo apt-get update
    sudo apt-get install -y stow git vim tmux fzf silversearcher-ag coreutils
else
    echo "❌ Unsupported platform. Need Homebrew or apt." >&2
    exit 1
fi

# 3. Setup Folders
echo "📁 Preparing directories..."
mkdir -p "$HOME/.vim/undo"
mkdir -p "$HOME/.tmux/plugins"

# 4. Clone TPM (Tmux Plugin Manager) if missing
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "🪟 Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# 5. Use GNU Stow to symlink everything
echo "🔗 Symlinking dotfiles with GNU Stow..."
cd "$HOME/dotfiles"
for dir in git tmux vim zsh; do
    echo "   Restowing $dir..."
    stow -R "$dir"
done

# 6. Finalizing
echo "✨ Setup complete!"
echo "👉 Run 'tmux source ~/.tmux.conf' inside tmux to reload."
echo "👉 Open vim and it will auto-install plugins."
echo "👉 Run 'source ~/.zshrc' to refresh your shell."
