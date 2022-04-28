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
ln -sf $PWD/sh/* ~/sh/

echo "Installing git scripts..."
if [ -d "pw-git-scripts" ]; then
    cd pw-git-scripts
    git fetch --all --prune
    cd -
else
    git clone https://github.com/slinkp/pw-git-scripts.git
fi
ln -sf $PWD/pw-git-scripts/git-* ~/sh/
cd $HOME

echo "Linking dotfiles..."
cd $HOME
ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
mkdir -p .config/dev
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
         gh git-delta \
         pandoc grip

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

    export SRCDIR=~/src/github.com/Shopify/shopify

    echo "Setting default shell to bash..."
    sudo chsh -s /bin/bash spin


    echo "Fixing git config..."
    git config --global --unset-all credential.helper

    echo "Installing extra packages..."
    echo "First some shenanigans for gh per https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrngs/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    echo "Now installing"
    for pkg in colordiff silversearcher-ag ripgrep tree rsync \
               psmisc lsof strace gdb \
               python3-matplotlib python3-pip python3-virtualenv python3-pygments \
               ncal \
               pandoc \
               gh; do
        sudo apt-get install -y $pkg
    done

    # For markdown previews via github api
    sudo pip3 install grip

    echo "Installing git-delta for my git config..."
    # Sadly not available for apt-get
    curl -L https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb > git-delta.deb && \
        sudo dpkg -i git-delta.deb
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
    yes | emacs --no-init-file --script $DOTFILES/emacs_bootstrap.el
    echo
    # May also need to do `M-x jedi:install-server` if still jedi problems?
    echo "Bootstrapped emacs"

    echo "Tags support for emacs..."
    cd $SRCDIR
    shadowenv exec -- gem install ripper-tags
    shadowenv exec -- ripper-tags -f TAGS -R -e components/ gems/ lib/
    cd -
    echo "Done with Spin setup"
fi

echo "Common things that depend on native installations above ..."
gh extension install Shopify/gh-draft-order-pr
