#!/bin/bash

# Function to check and remove Go installed with apt
remove_go_apt() {
  if dpkg -l | grep -qw golang-go; then
    echo "Removing Go installed with apt..."
    sudo apt-get remove --purge -y golang-go
    sudo apt-get autoremove -y
  fi
}

# Remove any Go installed with apt before proceeding
remove_go_apt

# Check if Go is already installed
if command -v go &>/dev/null; then
  echo "Go is already installed."
  go version
  exit 0
fi

# Change to the home directory
cd ~ || {
  echo "Failed to change directory to home"
  exit 1
}

# Define the Go tarball filename
GO_TARBALL="go1.22.5.linux-amd64.tar.gz"

# Check if the tarball is already downloaded
if [ ! -f "$GO_TARBALL" ]; then
  echo "$GO_TARBALL not found. Downloading now..."

  # Download the latest Go binary
  wget https://go.dev/dl/$GO_TARBALL
else
  echo "$GO_TARBALL already downloaded."
fi

# Setup environment variables only if Go wasn't already installed
if [ ! -d "/usr/local/go" ]; then
  echo "Go is not extracted. Proceeding with extraction."

  # Extract the archive
  sudo tar -C /usr/local -xzf $GO_TARBALL

  echo "Setting up environment variables for Go."
  current_shell=$(basename "$SHELL")

  case "$current_shell" in
  bash)
    if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.bashrc; then
      echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.bashrc
    fi
    if ! grep -q 'export GOPATH=$HOME/go' ~/.bashrc; then
      echo 'export GOPATH=$HOME/go' >>~/.bashrc
    fi
    if ! grep -q 'export PATH=$PATH:$GOPATH/bin' ~/.bashrc; then
      echo 'export PATH=$PATH:$GOPATH/bin' >>~/.bashrc
    fi
    source ~/.bashrc
    ;;
  zsh)
    if ! grep -q 'export PATH=$PATH:/usr/local/go/bin' ~/.zshrc; then
      echo 'export PATH=$PATH:/usr/local/go/bin' >>~/.zshrc
    fi
    if ! grep -q 'export GOPATH=$HOME/go' ~/.zshrc; then
      echo 'export GOPATH=$HOME/go' >>~/.zshrc
    fi
    if ! grep -q 'export PATH=$PATH:$GOPATH/bin' ~/.zshrc; then
      echo 'export PATH=$PATH:$GOPATH/bin' >>~/.zshrc
    fi
    source ~/.zshrc
    ;;
  *)
    echo "Unsupported shell: $current_shell"
    echo "Please manually add the Go environment variables to your shell configuration file."
    ;;
  esac
else
  echo "Go is already extracted in /usr/local/go. No need to download or extract again."
fi

# Verify the Go installation
go version
