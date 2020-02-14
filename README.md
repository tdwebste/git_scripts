git tips
=======

grep all branches
```
git grep <regexp> $(git rev-list --all)
alias grep_all="git branch -a | tr -d \* | sed '/->/d' | grep -v HEAD |xargs git grep"
```
find file in all branches
```
git log --all --source --pretty=oneline -- path_to_file
```
exclude files from match
```
git grep -l  pattern -- './' ':!*/sensor/libs/*'
https://kgrz.io/git-intro-to-pathspec.html
https://git-scm.com/docs/gitglossary.html#def_pathspec
top, exclude, icase, literal
:(top,exclude) etc
```

https://itextpdf.com/en/blog/technical-notes/how-completely-remove-file-git-repository

```
git log format cheatsheet
```
https://devhints.io/git-log-format


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
ln -s ~/src/git_scripts/.gitignore
ln -s ~/src/git_scripts/.vimrc
```
Optional
==
```
cp ~/src/git_scripts/bin/* ~/bin
```

