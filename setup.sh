#!/bin/bash
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
if which apt-get >/dev/null; then
	sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools
else
	sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel	
fi
sudo easy_install -ZU autopep8 twisted
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
mv ~/vim ~/vim_old -f
cd ~/ && git clone https://github.com/ma6174/vim.git
mv ~/.vim ~/.vim_old -f
mv ~/vim ~/.vim -f
mv ~/.vim/.vimrc ~/ -f
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
echo "ma6174正在努力为您安装bundle程序" > ma6174
echo "安装完毕将自动退出" >> ma6174
echo "请耐心等待" >> ma6174
vim ma6174 -c "BundleInstall" -c "q" -c "q"
rm ma6174
echo "安装完成"
