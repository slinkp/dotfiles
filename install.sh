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

ln -sf $DOTFILES/vimrc .vimrc

ln -sf $DOTFILES/pythonrc .pythonrc

# Some mac customizations: keyboard window management
mv .hammerspoon .hammerspoon-OLD 2> /dev/null
ln -sf $DOTFILES/hammerspoon .hammerspoon
ln -sf $DOTFILES/slate.js .slate.js
ln -sf $DOTFILES/slate .slate

if [ -n "$SPIN" ]; then
    if [ -n "$SPIN_WORKSPACE" ]; then
        export SPIN_CLASSIC=1
    fi

    # Works on both classic and isospin
    export SRCDIR=$SPIN_REPO_SOURCE_PATH

    echo "Setting default shell to bash..."
    sudo chsh -s /bin/bash spin


    echo "Fixing git config..."
    git config --global --unset-all credential.helper

    echo "Installing extra packages..."
    for pkg in colordiff silversearcher-ag ripgrep python-pygments tree rsync \
               psmisc lsof strace gdb \
               python3-matplotlib python3-pip python3-virtualenv ncal ; do
        sudo apt-get install -y $pkg
    done

    cd ~
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

    echo
    echo "Bootstrapping emacs packages"
    yes | emacs --script $DOTFILES/emacs_bootstrap.el
    echo
    # May also need to do `M-x jedi:install-server` if still jedi problems?

    echo "Tags support for emacs..."
    gem install ripper-tags
    cd $SRCDIR
    ripper-tags -f TAGS -R -e components/ gems/ lib/
    cd -
fi

echo "Byte compiling elisp files"
cd ~
emacs --batch --eval '(byte-compile-file (expand-file-name "~/.emacs"))'
emacs --batch --eval '(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)'
# Not working, refresh harder! argh
emacs --batch --eval '(byte-compile-file (expand-file-name "~/.emacs"))'
