#!/bin/bash

ln -sf ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/nvim ~/.config/
ln -sf ~/dotfiles/lf ~/.config/

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

#fd is needed for virtual environment selector https://github.com/linux-cultist/venv-selector.nvim
sudo apt install fd-find
