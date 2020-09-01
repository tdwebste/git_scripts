disable touchpad
===============

xinput list | grep -i touch
xinput disable 16
xinput enable 16

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
git clone https://github.com/git/git --depth 1 -b master

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

Vim IDE
==
install neovim

https://github.com/neovim/neovim/wiki/Installing-Neovim#appimage-universal-linux-package

more complex sudo apt-get install neovim ctags vim-scripts python3-neovim

for linux simply run
```
~/src/bin/setup_vim.sh
```


https://v2.onivim.io/downloads/Onivim2-x86_64.AppImage?channel=nightly&token=eyJhbGciOiJSUzI1NiIsImtpZCI6IjYzZTllYThmNzNkZWExMTRkZWI5YTY0OTcxZDJhMjkzN2QwYzY3YWEiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vb25pdmltIiwiYXVkIjoib25pdmltIiwiYXV0aF90aW1lIjoxNTgxODIyMjA4LCJ1c2VyX2lkIjoibGs6RkJDMjlFMTItRThFRC00NDI2LUI4N0EtQURGNTdBRjEwMUNCIiwic3ViIjoibGs6RkJDMjlFMTItRThFRC00NDI2LUI4N0EtQURGNTdBRjEwMUNCIiwiaWF0IjoxNTgxODIyMjA4LCJleHAiOjE1ODE4MjU4MDgsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnt9LCJzaWduX2luX3Byb3ZpZGVyIjoiY3VzdG9tIn19.aY8836CRYB-9a7xCTpIepwL2IilMWq9UK7tMijDu-l8IXlFRq86bkI2XTHschs5_119IPdmB5WDi_cX1irsy3esP8XmRAwwMM9qanoCgmvTab0mv8qT1feubLq6qcQV-4FoszZhvqcoGLnpcRJkJ-HMxvOjdpedxdT6BmagWTccouzitwV2uJ7gNEwvrqYYF0o28gr_Fyt8zPMEWgDzQgw2zt6gm5qJfAGgRfLRtSwisX7pblzzn7Z0lVlyeEk43GS_R2rUvNNtJHB4vEDYBZA73qcn7u4xj2nKGW_YqozrKWnCjkmNK7JCUbVIvMasavQzG3__KD8RvLxlB_Yah1w

FBC29E12-E8ED-4426-B87A-ADF57AF101CB
