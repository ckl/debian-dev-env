#!/bin/bash

# in vmware, set network adapter to bridge. then type:
# sudo service networking restart

# putty settings:
# No bell
# Temporary disable bell
#   over-use: 1
#   in seconds: 1
#   silence required: 999999
# Font: Lucida Console, 10-point
# Font quality: ClearType
# Gap between window/edge: 10
# Full screen on Alt-Enter
# Connection > Data > Terminal-string-type: xterm-256color

# general settings:
# ssh on different port: /etc/ssh/sshd_config


sudo apt-get update
# uncomment next line for vmware installs
#sudo apt-get install --assume-yes open-vmware-tools

sudo apt-get install --assume-yes git python3 pylint htop tmux virtualenv exuberant-ctags

# start cloning git repos
mkdir -p ~/gitrepos
git clone https://github.com/ckl/debian-dev-env.git ~/gitrepos/debian-dev-env
git clone https://github.com/ckl/dotvim.git ~/gitrepos/dotvim
git clone https://github.com/ckl/tmuxconf.git ~/gitrepos/tmuxconf
git clone https://github.com/tmux-plugins/tmux-resurrect.git ~/gitrepos/tmux-resurrect
git clone https://github.com/VundleVim/Vundle.vim.git ~/gitrepos/Vundle.vim

# link stuff to git repos
mkdir -p ~/bin
ln -s ~/gitrepos/debian-dev-env/pylintrc ~/.pylintrc
ln -s ~/gitrepos/debian-dev-env/ssh_man.py ~/bin/s
cp ~/gitrepos/debian-dev-env/ssh_hosts.ini ~/.ssh_hosts.ini
ln -s ~/gitrepos/dotvim ~/.vim
ln -s ~/gitrepos/dotvim/vimrc ~/.vimrc
ln -s ~/gitrepos/Vundle.vim ~/.vim/bundle/Vundle.vim
ln -s ~/gitrepos/tmuxconf/tmux.conf ~/.tmux.conf

# install vim and its plugins
sudo apt-get install --assume-yes vim vim-youcompleteme
vam install youcompleteme
vim +PluginInstall +qall
cp /usr/share/doc/vim-youcompleteme/examples/ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py

echo "alias vi='vim -X'" >> ~/.profile
echo "alias ls='ls -lhF --color=auto'" >> ~/.profile
echo "alias ga='git add'" >> ~/.profile
echo "alias gs='git status'" >> ~/.profile
echo "alias gc='git commit'" >> ~/.profile
echo "alias gl='git log -p'" >> ~/.profile
echo "alias gd='git diff'" >> ~/.profile
echo "stty -ixon  # prevents Ctrl-S freezes in putty" >> ~/.bashrc
echo 'PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:[\[\033[33;1m\]\w\[\033[32m\]] \[\033[1;33m\]-> \[\033[0m\]"' >> ~/.bashrc


