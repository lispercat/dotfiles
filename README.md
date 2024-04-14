# dot files

### Installation
* cd
* git clone https://github.com/lispercat/dotfiles.git
* cd dotfiles
* ./setup.sh

### Neovim:
* Since it's better to build/install neovim locally, follow [instructions](https://github.com/neovim/neovim/blob/master/BUILD.md)

### Python
* Install nvm (so that the newest version of node js could be install)
* Using nvm install latest node js
* remove .local/share/nvim and run nvim again letting LazyVim populate it again now based on the latest NodeJS version
* Now you can open python file and the LSP will work
* When you open a python file, you can press F5 to activate the python REPL in slime and then press C-c C-c to evaluate the code (chose defaults to connect to the REPL)

### [lf file manager](https://github.com/gokcehan/lf)
* Download the [latest binaries](https://github.com/gokcehan/lf/releases/download/r32/lf-linux-amd64.tar.gz) from the [releases](https://github.com/gokcehan/lf/releases) and put the lf under /usr/local/bin folder


