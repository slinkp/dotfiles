#!/bin/sh


DOTFILES=`(cd "${0%/*}" 2>/dev/null; echo "$PWD")`

cd $HOME

ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
ln -sf $DOTFILES/bash_github .bash_github
ln -sf $DOTFILES/git-completion.bash .git-completion.bash
ln -sf $DOTFILES/gitignore .gitignore

ln -sf $DOTFILES/dotemacs/.emacs .
ln -sf $DOTFILES/dotemacs/.emacs.d .

ln -sf $DOTFILES/pythonrc .pythonrc

if [ -n "$SPIN" ]; then

    export SRCDIR=$HOME/src/github.com/shopify/shopify

    echo "Setting default shell to bash..."
    sudo chsh -s /bin/bash spin


    echo "Fixing git config..."
    git config --global --unset-all credential.helper

    echo "Installing extra packages..."
    for pkg in colordiff silversearcher-ag ripgrep python-pygments tree rsync; do
        sudo apt-get install -y $pkg
    done

    mkdir -p sh
    mkdir -p tmp

    echo "Installing diff-so-fancy for my git config..."
    cd tmp
    git clone https://github.com/so-fancy/diff-so-fancy.git
    sudo mv -f diff-so-fancy/diff-so-fancy /usr/local/bin/
    sudo cp -r diff-so-fancy/lib /usr/local/bin

    echo "Installing shell scripts..."
    git clone https://github.com/slinkp/sh.git
    cp -f sh/* ../sh/

    git clone https://github.com/slinkp/pw-git-scripts.git
    cp -f pw-git-scripts/* ../sh/

    echo "Cleanup..."
    cd $HOME
    rm -rf tmp

    echo "Tags support for emacs..."
    gem install ripper-tags
    cd $SRCDIR
    ripper-tags -f TAGS -R -e components/ gems/ lib/ eagerlib/
    cd -

    echo
    echo "Bootstrapping emacs packages"
    yes | emacs --script $DOTFILES/emacs_bootstrap.el
    echo
fi

echo "Byte compiling elisp files"
cd ~
emacs --batch --eval '(byte-compile-file (expand-file-name "~/.emacs"))'
emacs --batch --eval '(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)'
# Not working, refresh harder! argh
emacs --batch --eval '(byte-compile-file (expand-file-name "~/.emacs"))'
