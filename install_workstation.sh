#!/bin/bash

# install sudo
# su
# apt-get update
# apt-get install sudo
# sudo adduser <username> sudo

# in vmware, set network adapter to bridge. then type:
# sudo service networking restart

# for a static ip, edit /etc/network/interfaces:
# The primary network interface
# allow-hotplug eth0
# iface eth0 inet static
#     address 10.1.1.125
#     netmask 255.0.0.0
#     gateway 10.1.1.1
#
# service networking restart

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
#
# vmware shared folders:
# 1.) apt-get install open-vm-tools                 (not sure if necessary, will test later)
# 2.) apt-get install linux-headers-$(uname -r)     (may also need to install linux-source)
# 3.) git clone https://github.com/rasa/vmware-tools-patches.git
# 4.) follow instructions to install, then set up shared folder in vmware and reboot
# 5.) sudo mount -t vmhgfs .host:/ /path/to/mount   -OR-
#     sudo mount -t vmhgfs .host:/share /path/to/mount/share

# Basic git setup:
# on workstation, run 'ssh-keygen -t rsa' and add to /home/git/.ssh/authorized_keys"
# to create a repo, run: "
# mkdir -p /home/git/project-1.git"
# cd /home/git/project-1.git"
# git init --bare"
# On the workstation, run: "
# mkdir -p project"
# cd project"
# git init"
# git add ."
# git commit -m 'message'"
# git remote add origin ssh://git@remote-server:port/home/git/project-1.git"
# git push origin master"
# on another workstation, clone git repo using: "
# git clone ssh://git@remote-server:port/home/git/project-1.git"
# to fully backup a git repo, run: "
# git clone --mirror ssh://git@remote-server:port/home/git/project-1.git"
# to update, run: "
# cd project-1.git"
# git remote update"


UTILITIES="bsd-mailx exim4-config exim4 python2.7 openssh-client bash-completion python mime-support exim4-daemon-light exim4-base htop ntp"
DEV_PACKAGES="vim vim-youcompleteme python3 python3-pip python3-pudb tmux exuberant-ctags"
UNINSTALL_PACKAGES="rpcbind"
PIP_PACKAGES="virtualenv autoenv"

echo "------------------------------------------"
echo "-- Setup debian development environment --"
echo "------------------------------------------"

echo "Running apt-get update..."
sudo apt-get -qq update

read -p "Remove $UNINSTALL_PACKAGES? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|n) ;;
    * ) sudo apt-get remove --purge --assume-yes $UNINSTALL_PACKAGES ;;
esac

read -p "Install utilities $UTILITIES? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|n) ;;
    * ) sudo apt-get -qq install --assume-yes $UTILITIES;;
esac

# vmware tools
read -p "Install open-vm-tools? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|n) ;;
    * ) sudo apt-get -qq install --assume-yes open-vm-tools ;;
esac

# git config
read -p "Install git and add configs? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *)   sudo apt-get -qq install --assume-yes git 
         git config --global color.ui true
         git config --global color.diff true
         git config --global color.status true
         git config --global color.branch true 
         git config --global alias.unstage = 'reset HEAD --'
         git config --global alias.last = 'log -1 HEAD'
         ;;
esac

read -p "Install git server? [y/N/q]: " choice
case "$choice" in
    q|Q) exit ;;
    y|Y) ;;
    *)  sudo apt-get install git-core
        sudo adduser git
        sudo passwd git
        sudo mkdir -p /home/git
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
read -p "Create symlinks and set permissions? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *)   echo "Creating symlinks and setting permissions..."
         mkdir -p ~/bin
         ln -s ~/gitrepos/debian-dev-env/pylintrc ~/.pylintrc
         ln -s ~/gitrepos/debian-dev-env/ssh_man.py ~/bin/s
         cp ~/gitrepos/debian-dev-env/ssh_hosts.ini ~/.ssh_hosts.ini
         cp ~/gitrepos/debian-dev-env/check_hosts.sh ~/bin/check_hosts
         ln -s ~/gitrepos/debian-dev-env/htoprc ~/.config/htop/htoprc
         ln -s ~/gitrepos/debian-dev-env/system_summary.sh ~/bin/system_summary
         ln -s ~/gitrepos/debian-dev-env/clear_screen.sh ~/bin/c
         ln -s ~/gitrepos/debian-dev-env/prompt_gitbranch ~/bin/prompt_gitbranch
         ln -s ~/gitrepos/debian-dev-env/create_virtualenv.sh ~/bin/create_virtualenv
         chmod +x ~/bin/s
         chmod +x ~/bin/c
         chmod +x ~/bin/get_git_branch
         chmod +x ~/bin/create_virtualenv
         chmod +x ~/bin/check_hosts
         ln -s ~/gitrepos/dotvim ~/.vim
         ln -s ~/gitrepos/dotvim/vimrc ~/.vimrc
         ln -s ~/gitrepos/Vundle.vim ~/.vim/bundle/Vundle.vim
         ln -s ~/gitrepos/tmuxconf/tmux.conf ~/.tmux.conf
         ln -s ~/bin/check_hosts /etc/cron.daily/check_hosts

         echo "update hosts in check_hosts and copy system_summary.sh to hosts as ~/bin/system_summary"
         ;;
 esac

# install vim, its plugins, and other dev stuff
read -p "Install dev packages $DEV_PACKAGES [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *) sudo apt-get -qq install --assume-yes $DEV_PACKAGES 
       vam install youcompleteme
       vim +PluginInstall +qall
       cp /usr/share/doc/vim-youcompleteme/examples/ycm_extra_conf.py ~/.vim/.ycm_extra_conf.py
       ;;
esac

read -p "Install pip3 packages $PIP_PACKAGES [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *) sudo pip3 install $PIP_PACKAGES 
       echo "source `which activate.sh`" >> ~/.bashrc
       ;;
esac


read -p "Create aliases and set prompt? [Y/n/q]: " choice
case "$choice" in
    q|Q) exit ;;
    n|N) ;;
    *) echo "Creating aliases and setting prompt..."
       cat ~/gitrepos/debian-dev-env/profile >> ~/.profile
       cat ~/gitrepos/debian-dev-env/bashrc >> ~/.bashrc
       cat ~/gitrepos/debian-dev-env/inputrc >> ~/.inputrc

       echo "run manually or logout and log back in:"
       echo -e "\tsource ~/.bashrc"
       echo -e "\tsource ~/.profile"
       echo -e "\tbind -f ~/.inputrc"
       ;;
esac
