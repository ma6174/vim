<head><meta charset="utf-8"></head>
#我的vim配置
##内容：
* vim的配置文件
* vim插件
* zsh配置文件

## 使用方法：
1. 安装vim `sudo apt-get install vim`
- 安装ctags：`sudo apt-get install ctags`
- `sudo ln -s /usr/bin/ctags /usr/local/bin/ctags`
- clone配置文件：`cd ~/ && git clone git://github.com/ma6174/vim.git`
- `mv ~/vim ~/.vim`
- `mv ~/.vim/.vimrc ~/`
- clone bundle 程序：`git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`
- 执行bundle程序`:BundleInstall`

## 2013年4月3日更新

1. 完善安装方法，修复bundle问题

## 2013年3月22日更新：

1. 修复bundle插件问题
-  修复ctags问题

## 2013年3月17日更新：
1. 增加go语言插件
- 增加bundle支持
- 修复小bug

##2012年7月28日更新：
1. 增加vimim输入法
* 增加多个pyhon插件,目前支持编码检测,自动增加文件头,自动补全,错误检测,一键执行python脚本
* 增加taglist
* 增加文件目录列表
* 增加日历功能
* 精简了一些没用的.vimrc 配置

##2012年8月4日更新：
1. 增加markdown插件
* 新建markdown文件自动添加表头"charset="utf-8"
* 按 md 直接生成对应的html文件，如a.md将生成a.md.html
* 按 fi 将在浏览器里面打开刚生成的页面进行预览

##2012年8月27日更新：
1. 增加zconding插件
* 增加graphviz插件，并设置F5自动执行

