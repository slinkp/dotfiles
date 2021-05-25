#!/bin/sh


DOTFILES=$PWD
cd $HOME

ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
ln -sf $DOTFILES/dotemacs/.emacs .
ln -sf $DOTFILES/dotemacs/.emacs.d .

if [ $SPIN ]; then

    # Default shell
    sudo chsh -s /bin/bash spin

    # Extra packages
    for pkg in colordiff silversearcher-ag python-pygments; do
        sudo apt-get install -y $pkg
    done
fi

echo
echo "Byte compiling emacs"

emacs --batch --eval '(byte-compile-directory "~/.emacs.d")'
emacs --batch --eval '(byte-compile-file "~/.emacs")'
