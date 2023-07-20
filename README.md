My dotfiles.

## Goal

Repeatable cross-platform setup of things I like.
All done via the `install.sh` script.

Do NOT download this and run `install.sh` without looking to see what it does.
It will clobber a lot of dotfiles in your home directory.

## Updating emacs config

Have not automated this, but: my [emacs config](https://github.com/slinkp/dotemacs)
is a subtree and needs to be pulled periodically via:

```console

git subtree pull --prefix dotemacs git@github.com:slinkp/dotemacs.git main
```
