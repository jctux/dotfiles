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
    brew install stow git vim tmux fzf ag coreutils zsh
elif command -v apt-get &>/dev/null; then
    echo "📦 Installing core packages (apt)..."
    if command -v sudo &>/dev/null; then
        SUDO="sudo"
    elif [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        echo "❌ Need sudo or root privileges to install packages." >&2
        exit 1
    fi

    ${SUDO} apt-get update
    ${SUDO} apt-get install -y stow git vim tmux fzf silversearcher-ag coreutils zsh
elif command -v dnf &>/dev/null; then
    echo "📦 Installing core packages (dnf)..."
    if command -v sudo &>/dev/null; then
        SUDO="sudo"
    elif [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        echo "❌ Need sudo or root privileges to install packages." >&2
        exit 1
    fi

    ${SUDO} dnf install -y git vim tmux coreutils zsh
    
    # Install optional packages if available (some may not exist in all repos)
    for pkg in stow fzf ripgrep; do
        if ${SUDO} dnf install -y "$pkg" 2>/dev/null; then
            echo "   ✓ Installed $pkg"
        else
            echo "   ⚠ Package $pkg not found (optional)"
        fi
    done
else
    echo "❌ Unsupported platform. Need Homebrew, apt, or dnf." >&2
    exit 1
fi

# 3. Setup Folders
echo "📁 Preparing directories..."
mkdir -p "$HOME/.vim/undo"
mkdir -p "$HOME/.tmux/plugins"

# 3b. Install stow if not available (especially for RHEL)
if ! command -v stow &>/dev/null; then
    echo "📦 Installing stow from source..."
    if command -v sudo &>/dev/null; then
        SUDO="sudo"
    elif [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        echo "⚠ Cannot install stow without sudo. Continuing without stow symlinks..." >&2
    fi
    
    if [ -n "$SUDO" ] || [ "$(id -u)" -eq 0 ]; then
        TEMP_DIR=$(mktemp -d)
        cd "$TEMP_DIR"
        
        # Download and build stow
        curl -fsSL https://ftp.gnu.org/gnu/stow/stow-latest.tar.gz -o stow.tar.gz
        tar xzf stow.tar.gz
        cd stow-*
        
        ./configure --prefix="$HOME/.local"
        make
        ${SUDO} make install
        
        # Add to PATH if not already there
        if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
            export PATH="$HOME/.local/bin:$PATH"
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.bashrc" 2>/dev/null || true
            echo "export PATH=\"\$HOME/.local/bin:\$PATH\"" >> "$HOME/.zshrc" 2>/dev/null || true
        fi
        
        cd /
        rm -rf "$TEMP_DIR"
        echo "   ✓ Stow installed to $HOME/.local/bin"
    fi
fi

# 4. Clone TPM (Tmux Plugin Manager) if missing
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "🪟 Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# 4b. Install Oh My Zsh if missing
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "💤 Installing Oh My Zsh..."
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
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
