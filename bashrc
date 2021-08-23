# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Are we on osx or linux?
if [ "$TERM_PROGRAM" == 'Apple_Terminal' -o "$TERM_PROGRAM" == 'iTerm.app' ]; then
	export IS_OSX=1
fi

if [ "$INSIDE_EMACS" == 'vterm' ]; then
    export IS_VTERM=1
fi

if [ -f /Applications/Emacs.app/Contents/MacOS/Emacs ]; then
	alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
fi

if [ -n "$IS_OSX" -o -n "$IS_VTERM" ]; then
	export CLICOLOR=1
else
	# default bashrc should already do this
	alias ls="/bin/ls --color=auto"
fi

if [ -n "`command -v htop`" ]; then
	alias top="htop"
fi

# safety
alias mv="/bin/mv -i"
alias cp="/bin/cp -i"
alias rm="/bin/rm -i"

# alias ftp="/usr/bin/tnftp"

# my functions
if [ -f "$HOME"/sh/pw_functions ]; then
    . $HOME/sh/pw_functions
fi

# For reference - i have this in global bashrc
PS1='\n\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\n\$\[\033[00m\] '
# without colors, do this:
#PS1='\u@\h \W \$ '


# Use GUI for ssh-add IF we're on X.
if [ -n "$DISPLAY" ]; then
	alias ssh-add="/usr/bin/ssh-add < /dev/null"
fi

if [ -n "$IS_OSX" ]; then
	alias xpdf=open
	alias xview=open
	alias epdfview=open
	alias updatedb="sudo /usr/libexec/locate.updatedb"
else
	# OSX-style "open" command.
 	# WARNING this shadows the /bin/open command which is an old name for openvt(1).
	if [ -f /usr/bin/xdg-open ]; then
		alias open=/usr/bin/xdg-open
	fi
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias dcomp="docker-compose"


# SHOPIFY LOCAL DEV
# load dev, but only if present and the shell is interactive
if [[ -f /opt/dev/dev.sh ]] && [[ $- == *i* ]]; then
  source /opt/dev/dev.sh
fi

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }

# SHOPIFY SPIN

if [ -n "$SPIN" ]; then
  alias mysql-spin="mysql -u root -h 127.0.0.1 -D shopify_dev_shard_0"
elif [ -n "$IS_OSX" ]; then
  source <(spin completion bash) 2>/dev/null
fi


