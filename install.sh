#!/bin/sh


DOTFILES=$PWD
cd $HOME

ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
ln -sf $DOTFILES/dotemacs/.emacs .emacs
ln -sf $DOTFILES/dotemacs/.emacs.d .emacs.d

if [ $SPIN ]; then
    for pkg in colordiff silversearcher-ag python-pygments; do
        sudo apt-get install -y $pkg
    done
fi
