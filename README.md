git tips
=======

grep all branches
git grep <regexp> $(git rev-list --all)
alias grep_all="git branch -a | tr -d \* | sed '/->/d' | xargs git grep"

find file in all branches
git log --all --source --pretty=oneline -- path_to_file

exclude files from match
git grep -l  pattern -- './' ':!*/sensor/libs/*'



git_scripts
===========

git tools and scripts

Setup
====
```
mkdir -p ~/src ~/bin; cd ~/src
git clone https://github.com/tdwebste/git_scripts.git
git clone https://github.com/git/git

cd ~
ln -s ~/src/git_scripts/.bashrc
ln -s ~/src/git_scripts/.gitconfig
ls -s ~/src/git_scripts/.gitignore
ls -s ~/src/git_scripts/.vimrc
```
Optional
==
```
cp ~/src/git_scripts/bin/* ~/bin
```

