# -*- mode: shell-script -*-
# .bashrc

# User specific aliases and functions

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Are we on osx or linux?
if [ "$TERM_PROGRAM" == 'Apple_Terminal' ] || [ "$TERM_PROGRAM" == 'iTerm.app' ]; then
	export IS_OSX=1
fi

if [ "$INSIDE_EMACS" == 'vterm' ]; then
    export IS_VTERM=1
fi

#if [ -f /Applications/Emacs.app/Contents/MacOS/Emacs ]; then
#	alias emacs=/Applications/Emacs.app/Contents/MacOS/Emacs
#fi

if [ -n "$IS_OSX" ] || [ -n "$IS_VTERM" ]; then
    # This may need tweaking. What about xterm-256 et al?
    export CLICOLOR=1
else
    alias ls="/bin/ls --color=auto"
fi

if [ -n "$(command -v htop)" ]; then
	alias top="htop"
fi

if [ -z "$(command -v python)" ] && [ -n "$(command -v python3)" ]; then
	alias python="python3"
fi


# safety
alias mv="/bin/mv -i"
alias cp="/bin/cp -i"
alias rm="/bin/rm -i"

# alias ftp="/usr/bin/tnftp"

# my functions
if [ -f "$HOME"/sh/pw_functions ]; then
    . "$HOME"/sh/pw_functions
fi

if [ "$CLICOLOR" -eq "1" ]; then
    PS1='\n\[\033[01;32m\]\u@\h\[\033[01;34m\] \W\n\$\[\033[00m\] '
else
    # without colors, do this:
    PS1='\u@\h \W\n\$ '
fi

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

[[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"


# Ruby version mgt via Frum https://github.com/TaKO8Ki/frum#bash

eval "$(frum init)"
# Not sure if I want to make a ~/.ruby_version or what, for now just doing
# `frum install 3.2.2`

# Used by haskell installer
[ -f "/Users/paul/.ghcup/env" ] && source "/Users/paul/.ghcup/env" # ghcup-env

# Direnv
[[ -x /usr/local/bin/direnv ]] && eval "$(/usr/local/bin/direnv hook bash)"

# Fix virtualenv PS1 when in direnv, as per direnv Python docs.
# https://github.com/direnv/direnv/wiki/Python#restoring-the-ps1
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
export -f show_virtual_env

