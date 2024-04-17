# dot files

### Installation
* cd
* git clone https://github.com/lispercat/dotfiles.git
* cd dotfiles
* ./setup.sh

### Neovim:
* Since it's better to build/install neovim locally, follow [instructions](https://github.com/neovim/neovim/blob/master/BUILD.md)

### Python (part of setup.sh script)
* Install nvm (so that the newest version of node js could be install)
  * Follow steps [here](https://www.geeksforgeeks.org/how-to-install-nvm-on-ubuntu-22-04/) 
* Using nvm install latest NodeJS
* remove .local/share/nvim and run nvim again letting LazyVim populate it again now based on the latest NodeJS version

### [lf file manager](https://github.com/gokcehan/lf) (part of setup.script)
* Download the [latest binaries](https://github.com/gokcehan/lf/releases/download/r32/lf-linux-amd64.tar.gz) from the [releases](https://github.com/gokcehan/lf/releases) and put the lf under /usr/local/bin folder

### Conjure
* The development in Python (and other languages) is based on [Conjure](https://github.com/Olical/conjure) 
* This added as a neovim plugin
