#!/bin/bash
pw=$PWD

if [ ! -d "$HOME/src" ]; then
    mkdir -p "$HOME/src"
fi
if [ ! -d "$HOME/bin" ]; then
    mkdir -p "$HOME/bin"
fi

cmd="find $HOME/src/git -name '.git' -prune"
if [ -z "$(eval $cmd)" ] ; then
    cd $HOME/src
    git clone https://github.com/git/git --depth 1
fi

cmd="find $HOME/.vim_runtime -name '.git' -prune"
if [ -z "$(eval $cmd)" ] ; then
    cd $HOME
    git clone https://github.com/tdwebste/vimrc ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    python update_plugins.py
    cat  ~/.vim_runtime/README_ycm.txt
fi

gitd="$HOME/src/git_scripts"
cmd="find $gitd -name '.git' -prune"
if [ -z "$(eval $cmd)" ] ; then
    cd $HOME/src
    git clone https://github.com/tdwebste/git_scripts.git
fi

if [ -d "$gitd/.git" ]; then
    mv ~/.bashrc ~/.bashrc.fb
    ln -s $gitd/.bashrc ~/.bashrc
    mv ~/.gitconfig ~/.gitconfig.fb
    ln -s $gitd/.gitconfig ~/.gitconfig
    mv ~/.tmux.conf ~/.tmux.conf.fb
    ln -s $gitd/.tmux.conf ~/.tmux.conf
    mv ~/.gdbinit ~/.gdbinit.fb
    ln -s $gitd/.gdbinit ~/.gdbinit

    cd $HOME/bin
    for f in $gitd/bin/*; do
        ln -s $gitd/bin/$f $HOME/bin/$f
    done
fi

exit

# https://idorobotics.com/2018/04/01/setting-up-vim-for-c-development/

cd $pw

#

