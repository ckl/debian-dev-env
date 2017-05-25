#!/bin/bash

# in vmware, set network adapter to bridge. then type:
# sudo service networking restart

# putty settings:
# run Liquid_Carbon_Transparent.reg (modify SESSION_NAME in file first)
# No bell
# Temporary disable bell
#   over-use: 1
#   in seconds: 1
#   silence required: 999999
# Font: Lucida Console, 10-point
# Font quality: ClearType
# Full screen on Alt-Enter
# Connection > Data > Terminal-string-type: xterm-256color

# general settings:
# ssh on different port: /etc/ssh/sshd_config
# ssh keys:
#   ssh-keygen -t rsa on host
#   transfer public key to server, put in ~/.ssh/_authorized_keys
#   move private key to ~/.ssh/id_rsa
PACKAGES="vim vim-youcompleteme python3 python3-pip python3-pudb htop tmux virtualenv exuberant-ctags"

echo "------------------------------------------"
echo "-- Setup debian development environment --"
echo "------------------------------------------"

echo "Running apt-get update..."
sudo apt-get -q update
# uncomment next line for vmware installs

read -p "Install open-vm-tools? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|n) ;;
    * ) sudo apt-get install --assume-yes open-vm-tools ;;
esac

# git config
read -p "Install git and configure for color? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *)   sudo apt-get -q install --assume-yes git 
         git config --global color.ui true
         git config --global color.diff true
         git config --global color.status true
         git config --global color.branch true 
         ;;
esac


# start cloning git repos
read -p "Clone github repos to ~/gitrepos? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *)   mkdir -p ~/gitrepos
         git clone https://github.com/ckl/debian-dev-env.git ~/gitrepos/debian-dev-env
         git clone https://github.com/ckl/dotvim.git ~/gitrepos/dotvim
         git clone https://github.com/ckl/tmuxconf.git ~/gitrepos/tmuxconf
         git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/gitrepos/tmux-resurrect
         git clone https://github.com/VundleVim/Vundle.vim.git ~/gitrepos/Vundle.vim
         ;;
esac

# link stuff to git repos

echo "Creating symlinks and setting permissions..."
mkdir -p ~/bin
ln -s ~/gitrepos/debian-dev-env/pylintrc ~/.pylintrc
ln -s ~/gitrepos/debian-dev-env/ssh_man.py ~/bin/s
cp ~/gitrepos/debian-dev-env/ssh_hosts.ini ~/.ssh_hosts.ini
ln -s ~/gitrepos/debian-dev-env/clear_screen ~/bin/c
chmod +x ~/bin/s
chmod +x ~/bin/c
ln -s ~/gitrepos/dotvim ~/.vim
ln -s ~/gitrepos/dotvim/vimrc ~/.vimrc
ln -s ~/gitrepos/Vundle.vim ~/.vim/bundle/Vundle.vim
ln -s ~/gitrepos/tmuxconf/tmux.conf ~/.tmux.conf

# install vim, its plugins, and other dev stuff
read -p "Install $PACKAGES [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *) sudo apt-get -q install --assume-yes $PACKAGES 
       vam install youcompleteme
       vim +PluginInstall +qall
       cp /usr/share/doc/vim-youcompleteme/examples/ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py
       ;;
esac


echo "Creating aliases and setting prompt..."
echo "alias vi='vim -X'" >> ~/.profile
echo "alias ls='ls -lhF --color=auto'" >> ~/.profile
echo "alias ga='git add'" >> ~/.profile
echo "alias gs='git status'" >> ~/.profile
echo "alias gc='git commit'" >> ~/.profile
echo "alias gl='git log -p'" >> ~/.profile
echo "alias gd='git diff'" >> ~/.profile
echo "stty -ixon  # prevents Ctrl-S freezes in putty" >> ~/.bashrc
echo 'PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:[\[\033[33;1m\]\w\[\033[32m\]] \[\033[1;33m\]-> \[\033[0m\]"' >> ~/.bashrc

source ~/.profile

cat ~/gitrepos/debian-dev-env/inputrc >> ~/.inputrc
bind -f ~/.inputrc
