#!/bin/bash

install_go() {
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
    return
  fi

  # Change to the home directory
  cd ~ || {
    echo "Failed to change directory to home"
    return 1
  }

  # Define the Go tarball filename
  local go_version="1.22.5"
  local go_tarball="go${go_version}.linux-amd64.tar.gz"
  local go_url="https://go.dev/dl/${go_tarball}"

  # Check if the tarball is already downloaded
  if [ ! -f "$go_tarball" ]; then
    echo "$go_tarball not found. Downloading now..."

    # Download the Go binary
    wget "$go_url"
  else
    echo "$go_tarball already downloaded."
  fi

  # Setup environment variables only if Go wasn't already installed
  if [ ! -d "/usr/local/go" ]; then
    echo "Go is not extracted. Proceeding with extraction."

    # Extract the archive
    sudo tar -C /usr/local -xzf "$go_tarball"

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
}

ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/nvim ~/.config/
ln -sf ~/dotfiles/lf ~/.config/

read -p "Do you want to clobber all nvim lazy local libraries (for complete refresh)? (yes/no): " answer
if [[ $answer =~ ^[Yy](es)?$ ]]; then
  rm -rf ~/.local/share/nvim
  rm -rf ~/.local/state/nvim
else
  echo "Skipping clobbering of nvim lazy libraries"
fi

#Install nvm and NodeJs and refresh neovim packages
# Prompt user to install NodeJS
read -p "Do you want to install the latest NodeJS? (yes/no): " answer
if [[ $answer =~ ^[Yy](es)?$ ]]; then
  sudo apt-get update
  sudo apt install curl
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
  nvm install --lts
  rm -rf ~/.local/share/nvim/
else
  echo "Skipping NodeJS installation."
fi

read -p "Do you want to install the latest lf file manager? (yes/no): " answer
if [[ $answer =~ ^[Yy](es)?$ ]]; then
  url="https://github.com/gokcehan/lf/releases/download/r32/lf-linux-amd64.tar.gz"
  dest_dir="/usr/local/bin/"
  tmp_dir="/tmp/lf"
  mkdir -p "$tmp_dir"
  wget "$url" -O "$tmp_dir/lf-linux-amd64.tar.gz"
  tar -xzf "$tmp_dir/lf-linux-amd64.tar.gz" -C "$tmp_dir"
  sudo cp "$tmp_dir/lf" "$dest_dir"
  rm -rf "$tmp_dir"
  echo "lf has been downloaded and extracted to $dest_dir"
else
  echo "Skipping lf file manager installation."
fi

# Prompt the user to confirm Go installation
read -p "Do you want to install the Go language? (yes/no): " install_go_choice
if [[ $install_go_choice =~ ^[Yy](es)?$ ]]; then
  install_go
else
  echo "Skipping Go installation."
fi

install_dotnet() {
  if ! command -v dotnet &>/dev/null; then
    echo "Installing .NET SDK..."
    sudo apt-get update && sudo apt-get install -y dotnet-sdk-8.0
  else
    echo ".NET SDK is already installed."
  fi
}
# Prompt to install .NET
read -p "Do you want to install .NET SDK? (yes/no): " install_dotnet_choice
if [[ $install_dotnet_choice =~ ^[Yy](es)?$ ]]; then
  install_dotnet
else
  echo "Skipping .NET SDK installation."
fi

#fd is needed for virtual environment selector https://github.com/linux-cultist/venv-selector.nvim
sudo apt install fd-find
sudo apt install ripgrep
