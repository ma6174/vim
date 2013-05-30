#!/bin/bash
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools
sudo easy_install -ZU autopep8 twisted
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
cd ~/ && git clone git://github.com/ma6174/vim.git
mv ~/vim ~/.vim
mv ~/.vim/.vimrc ~/
git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vi ma6174 -c "BundleInstall" -c "q" -c "q"
echo "安装完成"
