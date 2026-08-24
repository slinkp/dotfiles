I got [vibe](https://github.com/lynaghk/vibe) installed locally. 
I want to bootstrap it with:
- my dotfiles repo bootstrapped
- omp installed

# Things that need doing:

- [ ] figure out how to add my dotfiles repo to the vibe vm bootstrap
- [ ] Run dotfiles/install.sh inside a vibe VM and iterate until there are no install errors
- [ ] log in to the vibe VM and iterate on bash config until there are no
      errors
      - [ ] Fix `-bash: /opt/homebrew/etc/bash_completion.d/*: No such file or directory`
- [ ] Get direnv working
  - [ ] including my pyproject skeleton
- [ ] Get emacs working
- [ ] Get omp working inside with my openrouter key and global omp config
- [ ] Make an image with my base stuff?
- [ ] Do NOT install omp via `curl ... | bash`, find something repeatable and
      safer. Version bump should only happen when I decide
- [ ] Audit my dotfiles installer for security
