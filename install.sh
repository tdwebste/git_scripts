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
    mv ~/.nvimrc ~/.nvimrc.fb
    ln -s $gitd/.vimrc_vundle ~/.nvimrc
    mv ~/.vimrc ~/.vimrc.fb
    ln -s $gitd/.vimrc_vundle ~/.vimrc
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
if [ -d "$HOME/.vim/bundle/Vundle.vim" ] ; then
    echo "vundle for vim already installed"
else
    mkdir -p $HOME/.vim/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
    vim +PluginInstall +qall
fi
if [ -d "$HOME/.vim/bundle/YouCompleteMe" ] ; then
    cd $HOME/.vim/bundle/
    git clone https://github.com/ycm-core/YouCompleteMe.git
    cd "$HOME/.vim/bundle/YouCompleteMe"
    git submodule update --init --recursive
    sudo apt install build-essential cmake python3-dev
    ./install.py --clangd-completer

fi

cd $pw

#

