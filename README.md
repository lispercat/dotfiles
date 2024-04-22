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

### Installig java
* `sudo apt-get install openjdk-11-jdk` (for Sailpoint IIQ)
* `sudo apt-get install openjdk-21-jdk` (for Fernflower and everyting else)
* use `sudo update-alternatives --config java` to switch versions

### Getting Fernflower (java decompiler) to work [from this page](https://www.jetbrains.com/intellij-repository/releases/) and search java-decompiler-engine.jar
* cd 
* `wget https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/241.14494.240/java-decompiler-engine-241.14494.240.jar`
* `mv java-decompiler-engine* java-decompiler-engine.jar`
* cd to your java project with jar or war files
* mkdir decompiled_java
* `java -jar ~/java-decompiler-engine.jar -hes=0 -hdc=0 ./src ./decompiled_java` where ./src is the source of you jar files
* `cd decompiled_java`
* Unzip jar files `find . -name '*.jar' -exec sh -c 'unzip -d "${1%.*}" "$1"' _ {} \;`





