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

git subtree pull --prefix dotemacs https://github.com/slinkp/dotemacs.git main --squash
```

## Mac dependencies not captured here

### Things that need installing first, before install.sh:

- [x] First update to latest (MacOS 14 as of writing)

- [x] Dropbox https://www.dropbox.com/install?
  TODO update this, things have moved
  - [x] add to login items
  - [ ] replace Documents with symlink to `/Users/paul/Library/CloudStorage/Dropbox/My Mac (Paul’s MacBook Pro)/Documents`
  - [ ] `ln -s /Users/paul/Library/CloudStorage/Dropbox ~/Dropbox`
  - [ ] `ln -s ~/Dropbox/bin ~/bin`
  - [ ] `ln -s ~/Dropbox/morestuff ~/morestuff`

- [x] Intel One mono font https://github.com/intel/intel-one-mono/ (OTF format)
  - [x] Download release OTF format
  - [x] open FontBook app and drag font file(s) to it

- [x] iterm2 https://iterm2.com/
  - To restore my settings:
  - [x] install Intel One font and Dropbox first
  - [x] install Dropbox and load stuff first
  - Settings -> General -> Preferences
    - check "Load preferences from a custom folder or URL"
    - browse to /Users/paul/Library/CloudStorage/Dropbox
     - [ ] TODO fix this after sorting out dropbox upgrade / data move
      - the file should automatically be loaded `com.googlecode.iterm2.plist`

- [x] Homebrew https://brew.sh/

- [x] **Then run the install script**!

### Other must-haves:


- [x] Firefox
  - Sync via https://accounts.firefox.com/
  - SimpleTabGroups:
    - I haven't found a way to automate this. Backup files are under folders
      named eg ~/Downloads/STG-backups-FF-(version)/
      and I can't control that.
    - Need to manually copy latest one(s) of those into eg dropbox and restore from it

- [x] Hammerspoon https://www.hammerspoon.org/
  - [x] add to login items
  - [x] enable accessibility and restart

### Less essential but I also want:

- [x] Monosnap (via app store)
  - [x] add to login items
  - [x] give permissions in settings
- [x] Zulip https://zulip.com/apps/mac
  - [x] reinstalled native apple build

- [Presonus Universal Control](https://legacy.presonus.com/products/Universal-Control/downloads?_gl=1*1dn4zz7*_ga*MTEyODA4NjU0NC4xNjg5MTk0MDI3*_ga_QW48WZWN0R*MTY5ODk3Njc4OS4yMzQuMS4xNjk4OTc4NTIyLjYwLjAuMA)

- Blackhole (see notes below)

Download: https://existential.audio/blackhole/

### Blackhole notes from [recurse zulip chat](https://recurse.zulipchat.com/#narrow/stream/26440-small-questions/topic/Screen.20capture.20with.20system.20audio.20on.20Mac.3F):

I managed to get Blackhole working as per the installation instructions and it
works well with recorder of choice (I'm still using Monosnap as I like the easy
quality settings).

There was a gotcha I discovered: When setting up the required Multi output
device, if you have a "ZoomAudioDevice" set up for zoom and choose that as one
of your outputs, then the mac won't won't let you choose your multi audio
device as audio output. DOn't know why. Removed that checkbox and all was well
:shrug:

Should be checked:
1. Builtin Output or Macbook Pro Speakers *OR* external headphones, not both.
2. Blackhole (with drift correction).

Should _not_ be checked: ZoomAudioDevice)

Also a little gotcha with this approach: if you switch between headphones and
speakers, you'll have to go into Audio Midi Setup and check/uncheck the desired
outputs every time you switch outputs.
