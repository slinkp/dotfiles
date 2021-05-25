# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs.

######################################################################
# python

# i like my path elements to come first, but not for libs.
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python:/usr/local/lib/python/site-packages:$HOME/bin/py
export PYTHONPATH=$PYTHONPATH:/usr/local/lib/python2.7:/usr/local/lib/python2.7/site-packages
if [ -e $HOME/Library/Python/2.7/lib/python/site-packages ]; then
    export PYTHONPATH=$PYTHONPATH:$HOME/Library/Python/2.7/lib/python/site-packages
fi

if [ -e $HOME/Library/Python/2.7/bin ]; then
    PATH=$HOME/Library/Python/2.7/bin:$PATH
fi

if [ -e /Library/Frameworks/Python.framework/Versions/3.6/bin ]; then
   PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
fi

BASH_ENV=$HOME/.bashrc
USERNAME=""

export USERNAME BASH_ENV ENV PATH

# turn on tab completion in interactive python
export PYTHONSTARTUP=~/.pythonrc

# Save time building crap
export PYTHON_EGG_CACHE=$HOME/.python-eggs


######################################################################
# ruby

if [ -e $HOME/.rvm/bin ]; then
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

for RUBY_VERSION in "2.7.0" "2.6.0"; do
    if [ -e $HOME/.gem/ruby/$RUBY_VERSION/bin ]; then
        PATH=$PATH:$HOME/.gem/ruby/$RUBY_VERSION/bin # For `gem install --user-install` stuff
    fi
done


######################################################################
# Misc

#export EDITOR='/usr/bin/emacs -nw'
export EDITOR=emacsclient
if [ "$IS_VTERM" ]; then
    # inside vterm this will open a new buffer :)
    export EDITOR='emacsclient'
    # vterm likes to set it to 'cat' which errr not great for big ooutput
    export PAGER='less'
fi


# Ardour
export ARDOURRC=$HOME/.ardourrc


# for slrn
#export NNTPSERVER=news.bellatlantic.net


# CVS
export CVS_RSH=ssh
export CVSEDITOR=vi

# rsync
export RSYNC_RSH=ssh


# Editor keybinding style for the shell
#set -o vi
set -o emacs

# Some bash completion stuff
export COMP_CVS_REMOTE=1
export COMP_CONFIGURE_HINTS=1

# Various things are happier with non-ASCII characters
# if I give them a clue what to do...
export LANG=en_US.UTF-8

# OpenOffice
LANGUAGE="en_US:en"

# Use unicode console font if possible, as per
# http://gentoo-wiki.com/HOWTO_Make_your_system_use_unicode/utf-8
if [ ! -n "$IS_OSX" ]; then
	if test -t 1 -a -t 2 ; then
       		echo -n -e '\033%G'
	fi
fi

# Gentoo has this already, but not Ubuntu.
export LESS="-R -M"

# Gnome does this automatically, but Roxterm doesn't seem to.
export SSH_ASKPASS=/usr/bin/ssh-askpass

# Don't download so darn much
export PIP_DOWNLOAD_CACHE=$HOME/tmp/pip-download-cache

# pip bash completion start
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
# pip bash completion end


# # Amazon EC2 stuff. For the sysop@openplans account,
# # used by ec2-* commands.
# export EC2_CERT=~/.ssh/cert-GOQRORCJPKJPP2L7Z7HE6SUHKP2DZXIJ.pem
# export EC2_PRIVATE_KEY=~/.ssh/pk-GOQRORCJPKJPP2L7Z7HE6SUHKP2DZXIJ.pem

# Other languages for PATH

for foo in $HOME/bin $HOME/bin/py $HOME/bin/perl $HOME/sh $HOME/bin/ruby; do
    if [ -e $foo ]; then
        PATH=$foo:$PATH
    fi
done


export GOROOT=/usr/local/go
PATH=$PATH:$GOROOT/bin

# Fix keyboard & touchpad.  TODO: move that to X configs that does the right thing to the right input.
# XXX This was for linux on macbook air. Doesn't seem good on macbook pro 12,1.
#if [ -n "$DISPLAY" ]; then
#	if [ ! -f /tmp/did_x_post_setup ]; then
#		(sleep 10 && ~/sh/x_post_setup) &
#	fi
#fi

# Iterm2 features per https://iterm2.com/documentation-shell-integration.html
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"


######################################################################
# PROMPT

# Add git branch info to PS1.
if [ -f ~/.bash_github ]; then
    . ~/.bash_github
fi

# I like to shove the time in there.
export PS1="[\t]\n$PS1"

######################################################################
# HISTORY
# 500 is way too low
export HISTSIZE=3000
export HISTFILESIZE=3000

# Better handling history from multiple terminals
# as per https://twitter.com/AreTillery/status/1262202552373960705
# Set an environment variable to force history saving with each prompt:
PROMPT_COMMAND='history -a'
# You probably want to set your history to append instead of overwrite too
shopt -s histappend

#######################################################################
# PATH finalization

# I prefer local stuff to override
PATH="/usr/local/bin:${PATH}"

#finally...
export PATH

######################################################################
# HANDSHAKE

if [ -f ~/.bash_profile_handshake ]; then
    . ~/.bash_profile_handshake
fi


######################################################################

if [ -e /Users/paul/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/paul/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
