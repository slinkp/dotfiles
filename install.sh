#!/bin/sh


DOTFILES=$PWD
cd $HOME

ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
ln -sf $DOTFILES/dotemacs/.emacs .emacs
ln -sf $DOTFILES/dotemacs/.emacs.d .emacs.d
