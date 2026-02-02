#!/bin/bash

# ----------------------------------------------------------------------------
#  Modern Dotfiles Bootstrap Script
# ----------------------------------------------------------------------------

set -e

echo "🚀 Starting Dotfiles Modernization..."

# 1. Install Homebrew if missing
if ! command -v brew &>/dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 2. Install essential tools
echo "📦 Installing core packages..."
brew install stow git vim tmux fzf ag coreutils

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
