#!/bin/sh


DOTFILES=`(cd "${0%/*}" 2>/dev/null; echo "$PWD")`

cd $HOME

#################################################################
# INITIAL SYSTEM-INDEPENDENT STUFF
#################################################################

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

ln -sf $DOTFILES/pryrc .pryrc

ln -sf $DOTFILES/tmux.conf .tmux.conf

################################################################################
# MAC SPECIFIC STUFF
################################################################################
if [ -n "$MACOS_SW_VERSION" ]; then

    # Some mac customizations: keyboard window management
    mv .hammerspoon .hammerspoon-OLD 2> /dev/null
    ln -sf $DOTFILES/hammerspoon .hammerspoon
    ln -sf $DOTFILES/slate.js .slate.js
    ln -sf $DOTFILES/slate .slate

    echo "Installing macos packages..."
    brew install colordiff the_silver_searcher ripgrep tree \
         pyenv diff-so-fancy pygments mplayer mp3info \
         gh git-delta \
         pandoc grip

    # Emacs for m1
    brew tap d12frosted/emacs-plus
    brew install emacs-plus@28 --with-native-comp --with-modern-papirus-icon

    # Launching via spotlight requires copying the .app directory, not symlinking...
    # which means we have to do this every time :(
    EMACSAPPDIR="$(dirname $(dirname $(readlink -f /opt/homebrew/bin/emacs)))/Emacs.app"
    if [ -d "$EMACSAPPDIR" ]; then
        echo Copying Emacs.app so we can launch it from spotlight...
        rm -rf ~/Applications/Emacs.app
        cp -rf $EMACSAPPDIR ~/Applications/
    fi

    # Don't let play/ff/rew keys launch apple music
    # per https://apple.stackexchange.com/questions/380126/do-not-open-apple-music-when-pressing-a-media-key
    launchctl bootout "gui/$(id -u "${USER}")/com.apple.rcd"
    launchctl disable "gui/$(id -u "${USER}")/com.apple.rcd"

    echo "Done with Mac setup"
fi

################################################################################
# SPIN SPECIFIC STUFF
################################################################################
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

    echo "Installing git ppa to get latest git ..."
    sudo add-apt-repository -y ppa:git-core/ppa

    echo "Installing emacs ppa..."
    sudo add-apt-repository -y ppa:kelleyk/emacs
    echo "Removing stock emacs..."
    sudo apt-get remove -y emacs emacs-common

    echo "Apt update and cleanup..."
    sudo apt update -y
    sudo apt autoremove -y

    echo "Installing extra packages..."
    sudo apt-get install -y colordiff silversearcher-ag ripgrep tree rsync \
               psmisc lsof strace gdb \
               python3-matplotlib python3-pip python3-virtualenv python3-pygments \
               ncal imagemagick \
               git \
               emacs28-nativecomp \
               pandoc

    echo "More apt cleanup..."
    sudo apt -y --fix-broken install
    sudo apt -y autoremove

    # For markdown previews via github api
    sudo pip3 install grip

    echo "Installing git-delta for my git config..."
    # Sadly not available for apt-get
    curl -L https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb > git-delta.deb && \
        sudo dpkg -i git-delta.deb
    cd ~

    echo "Installing diff-so-fancy for my git config..."
    cd ~/src
    rm -rf diff-so-fancy
    git clone https://github.com/so-fancy/diff-so-fancy.git
    sudo mv -f diff-so-fancy/diff-so-fancy /usr/local/bin/
    sudo cp -r diff-so-fancy/lib /usr/local/bin
    cd -

    echo
    echo "Bootstrapping emacs packages"
    # This is a hack that just saves some time on initial emacs startup.
    # If we skip this, it just means that the first time I open emacs,
    # `straight` will go and fetch & install all my missing emacs packages.
    yes | emacs --no-init-file --script $DOTFILES/emacs_bootstrap.el
    echo
    # May also need to do `M-x jedi:install-server` if still jedi problems?
    echo "Bootstrapped emacs"

    echo "Tags support for emacs xref completion ..."
    cd $SRCDIR
    shadowenv exec -- gem install ripper-tags
    nohup shadowenv exec -- ripper-tags -f TAGS -R -e components/ gems/ lib/ &
    cd -
    echo "Done with Spin setup"
fi

#################################################################
# FINAL SYSTEM-INDEPENDENT STUFF
#################################################################

