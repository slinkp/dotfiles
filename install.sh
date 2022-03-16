#!/bin/sh


DOTFILES=`(cd "${0%/*}" 2>/dev/null; echo "$PWD")`

cd $HOME


echo "Installing shell scripts..."
mkdir -p ~/src
mkdir -p ~/sh
cd ~/src
if [ -d "sh" ]; then
    cd sh
    git fetch --all --prune
    cd -
else
    git clone https://github.com/slinkp/sh.git
fi
ln -sf sh/* ~/sh/

echo "Installing git scripts..."
if [ -d "pw-git-scripts" ]; then
    cd pw-git-scripts
    git fetch --all --prune
    cd -
else
    git clone https://github.com/slinkp/pw-git-scripts.git
fi
ln -sf pw-git-scripts/* ~/sh/
cd $HOME

echo "Linking dotfiles..."
cd $HOME
ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
mkdir -p .config/dev
ln -sf $DOTFILES/shopify_gitconfig .config/dev/gitconfig
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

if [ -n "$MACOS_SW_VERSION" ]; then
    echo "Installing macos packages..."
    brew install colordiff the_silver_seacher ripgrep tree \
         pyenv diff-so-fancy pygments mplayer mp3info \
         gh

    # Emacs for m1
    brew tap d12frosted/emacs-plus
    brew install emacs-plus@28 --with-native-comp --with-modern-papirus-icon

    echo "Done with Mac setup"
fi

if [ -n "$SPIN" ]; then
    echo "Installing spin-specific things..."
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
               python3-matplotlib python3-pip python3-virtualenv ncal \
               gh; do
        sudo apt-get install -y $pkg
    done
    cd ~

    echo "Installing diff-so-fancy for my git config..."
    cd ~/src
    git clone https://github.com/so-fancy/diff-so-fancy.git
    sudo mv -f diff-so-fancy/diff-so-fancy /usr/local/bin/
    sudo cp -r diff-so-fancy/lib /usr/local/bin
    cd -
    rm -rf diff-so-fancy

    echo
    echo "Bootstrapping emacs packages"
    yes | emacs --script $DOTFILES/emacs_bootstrap.el
    echo
    # May also need to do `M-x jedi:install-server` if still jedi problems?

    echo "Tags support for emacs..."
    cd $SRCDIR
    gem install ripper-tags
    ripper-tags -f TAGS -R -e components/ gems/ lib/
    cd -
    echo "Done with Spin setup"
fi

echo "Common things that depend on native installations above ..."
gh extension install Shopify/gh-draft-order-pr


echo "Emacs setup - broken :("
echo "Byte compiling elisp files"
cd ~
emacs --batch --eval '(byte-compile-file (expand-file-name "~/.emacs"))'
emacs --batch --eval '(byte-recompile-directory (expand-file-name "~/.emacs.d") 0)'
# Not working, refresh harder! argh
emacs --batch --eval '(byte-compile-file (expand-file-name "~/.emacs"))'
