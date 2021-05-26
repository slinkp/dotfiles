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

    mkdir -p sh
    mkdir -p tmp

    # diff-so-fancy needed by my git config
    cd tmp
    git clone https://github.com/so-fancy/diff-so-fancy.git
    sudo mv -f diff-so-fancy/diff-so-fancy /usr/local/bin/
    sudo cp -r diff-so-fancy/lib /usr/local/bin

    # Shell stuff
    git clone https://github.com/slinkp/sh.git
    cp -f sh/* ../sh/

    git clone https://github.com/slinkp/pw-git-scripts.git
    cp -f pw-git-scripts/* ../sh/

    # Cleanup
    cd $HOME
    rm -rf tmp

    # Tags for emacs
    gem install ripper-tags
    ripper-tags -f TAGS -R -e components/ gems/ lib/ eagerlib/
fi

echo
echo "Byte compiling emacs"

# First need to run to ensure use-package is installed
yes | emacs --script $DOTFILES/emacs_bootstrap.el

# Byte compile files
emacs --batch --eval '(byte-compile-file "~/.emacs")'
# Compile everything hopefully?
emacs --batch --eval '(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)'
# Redundant? Not sure
emacs --batch --eval '(byte-compile-file "~/.emacs")'
