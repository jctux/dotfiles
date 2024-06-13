#!/bin/bash

# Function to install packages on CentOS
install_centos() {
    sudo yum update -y
    sudo yum install -y epel-release
    sudo yum install -y stow git zsh vim tmux
}

# Function to install packages on Ubuntu
install_ubuntu() {
    sudo apt update
    sudo apt install -y stow git zsh vim tmux
}

# Function to install packages on macOS using Homebrew
install_macos() {
    # Check if Homebrew is installed, install if not
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found, installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    brew update
    brew install stow git zsh vim tmux
}

# Determine the operating system
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
else
    OS=$(uname -s)
fi

# Execute the installation based on the OS
case "$OS" in
    "CentOS Linux")
        echo "Detected CentOS"
        install_centos
        ;;
    "Ubuntu")
        echo "Detected Ubuntu"
        install_ubuntu
        ;;
    "Darwin")
        echo "Detected macOS"
        install_macos
        ;;
    *)
        echo "Unsupported OS: $OS"
        exit 1
        ;;
esac

echo "Installation complete!"
