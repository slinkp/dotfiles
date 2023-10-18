#!/bin/sh


DOTFILES=`(cd "${0%/*}" 2>/dev/null; echo "$PWD")`

cd $HOME || exit 1

################################################################
# Detect system
################################################################

case "$(uname -sr)" in
    Darwin*)
        echo 'Will install Mac-specific things'
        export IS_MACOS=1
        ;;
    Linux*)
        echo 'We are on some flavor of Linux'
        # Note: Linux*Microsoft*) would match windows subsystem for linux
        export IS_LINUX=1
        export APT=`which apt`
        if [ -n "$APT" ]; then
            echo Apt found at "$APT", will install for Linux
        else
            echo "Apt not found, exiting"
            exit 1
        fi
        ;;
    *)
        echo "Unhandled OS `uname -sr`, exiting $1"
        exit 1
        ;;
esac

#################################################################
# INITIAL SYSTEM-INDEPENDENT STUFF
#################################################################

echo "Installing shell scripts..."
mkdir -p ~/src || exit 1
mkdir -p ~/sh || exit 1
cd ~/src || exit 1

if [ -d "sh" ]; then
    cd sh || exit 1
    git fetch --all --prune
    cd - || exit 1
else
    git clone https://github.com/slinkp/sh.git
fi
ln -sf $PWD/sh/* ~/sh/

echo "Installing git scripts..."
if [ -d "pw-git-scripts" ]; then
    cd pw-git-scripts || exit 1
    git fetch --all --prune
    cd - || exit 1
else
    git clone https://github.com/slinkp/pw-git-scripts.git
fi
ln -sf $PWD/pw-git-scripts/git-* ~/sh/
cd $HOME || exit 1

echo "Linking dotfiles..."
cd $HOME || exit 1
ln -sf $DOTFILES/bash_profile .bash_profile
ln -sf $DOTFILES/bashrc .bashrc
ln -sf $DOTFILES/gitconfig .gitconfig
ln -sf $DOTFILES/bash_github .bash_github
ln -sf $DOTFILES/git-completion.bash .git-completion.bash
ln -sf $DOTFILES/gitignore .gitignore
ln -sf $DOTFILES/guile .guile

ln -sf $DOTFILES/dotemacs/.emacs .
ln -sf $DOTFILES/dotemacs/.emacs.d .

ln -sf $DOTFILES/vimrc .vimrc

ln -sf $DOTFILES/pythonrc .pythonrc

ln -sf $DOTFILES/pryrc .pryrc

ln -sf $DOTFILES/tmux.conf .tmux.conf

################################################################################
# MAC SPECIFIC STUFF
################################################################################
if [ -n "$IS_MACOS" ]; then

    # Some mac customizations: keyboard window management
    rm -rf .hammerspoon-OLD
    mv .hammerspoon .hammerspoon-OLD 2> /dev/null
    ln -sf $DOTFILES/hammerspoon .hammerspoon
    rm -f .hammerspoon/hammerspoon  # annoying ln behavior
    ln -sf $DOTFILES/slate.js .slate.js
    ln -sf $DOTFILES/slate .slate

    echo "Installing macos packages..."
    brew install colordiff the_silver_searcher ripgrep tree \
         pyenv pygments mplayer mp3info \
         gh git-delta \
         difftastic \
         pandoc grip \
         shellcheck \
         frum libyaml \  # For Ruby management
         fzf

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

    # Ruby
    eval "$(frum init)"
    frum install 3.2.2

    echo "Done with Mac setup"
fi

###############################################################################
# Linux specific stuff

if [ -n "$IS_LINUX" ] && [ -n "$APT" ]; then
    # echo "Setting default shell to bash..."
    sudo chsh -s /bin/bash USERNAME

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
               pandoc \
               shellcheck \
               fzf \
               difftastic  # TODO unsure if there's an ubuntu package for this

    echo "More apt cleanup..."
    sudo apt -y --fix-broken install
    sudo apt -y autoremove

    # For markdown previews via github api
    sudo pip3 install grip

    echo "Installing git-delta for my git config..."
    # Sadly not available for apt-get
    curl -L https://github.com/dandavison/delta/releases/download/0.12.1/git-delta_0.12.1_amd64.deb > git-delta.deb && \
        sudo dpkg -i git-delta.deb
    cd ~ || exit 1

    echo
    echo "Bootstrapping emacs packages"
    # This is a hack that just saves some time on initial emacs startup.
    # If we skip this, it just means that the first time I open emacs,
    # `straight` will go and fetch & install all my missing emacs packages.
    yes | emacs --no-init-file --script $DOTFILES/emacs_bootstrap.el
    echo
    # May also need to do `M-x jedi:install-server` if still jedi problems?
    echo "Bootstrapped emacs"

    #echo "Tags support for emacs xref completion ..."
    #cd $SRCDIR
    #sudo gem install ripper-tags
    #ripper-tags -f TAGS -R -e components/ gems/ lib/ &
    #cd -
    echo "Done with debian? ubuntu? setup"
fi

#################################################################
# FINAL SYSTEM-INDEPENDENT STUFF
#################################################################

