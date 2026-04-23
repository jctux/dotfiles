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

    # Install core packages first
    ${SUDO} dnf install -y git vim tmux coreutils zsh
    
    # Try to enable EPEL repository and install stow
    echo "   📚 Attempting to enable EPEL repository for stow..."
    
    # Try epel-release package first
    if ! ${SUDO} dnf install -y epel-release 2>/dev/null; then
        # For RHEL 10+, try installing EPEL directly from URL
        RHEL_VERSION=$(grep -oP '(?<=VERSION_ID=")[^"]*' /etc/os-release 2>/dev/null || echo "")
        if [[ "$RHEL_VERSION" =~ ^10 ]]; then
            echo "   📥 Installing EPEL for RHEL 10 from direct URL..."
            ${SUDO} dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-10.noarch.rpm 2>/dev/null || true
        fi
    fi
    
    # Try to install stow (may still fail if EPEL isn't available)
    if ${SUDO} dnf install -y stow 2>/dev/null; then
        echo "   ✓ Installed stow"
    else
        echo "   ⚠ Could not install stow - will attempt manual symlinks"
    fi
    
    # Install optional packages if available
    for pkg in fzf ripgrep; do
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

# 4c. Install zsh plugins if missing
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "💡 Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "🎨 Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 5. Use GNU Stow to symlink everything (or fallback to manual symlinks)
echo "🔗 Symlinking dotfiles..."
cd "$HOME/dotfiles"

if command -v stow &>/dev/null; then
    echo "Using GNU Stow..."
    for dir in git tmux vim zsh; do
        echo "   Restowing $dir..."
        stow -R "$dir"
    done
else
    echo "⚠ Stow not available, using manual symlinks..."
    for dir in git tmux vim zsh; do
        echo "   Creating symlinks for $dir..."
        for file in "$dir"/.*; do
            [ -f "$file" ] || continue
            filename=$(basename "$file")
            target="$HOME/$filename"
            
            if [ -e "$target" ] || [ -L "$target" ]; then
                echo "      ⚠ $target already exists, skipping"
            else
                ln -s "$(pwd)/$file" "$target"
                echo "      ✓ Linked $filename"
            fi
        done
    done
fi

# 6. Finalizing
echo "✨ Setup complete!"
echo "👉 Run 'tmux source ~/.tmux.conf' inside tmux to reload."
echo "👉 Open vim and it will auto-install plugins."
echo "👉 Run 'source ~/.zshrc' to refresh your shell."
