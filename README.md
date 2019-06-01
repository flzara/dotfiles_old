# My dotfiles

**OLD VERSION. Not to be used. See https://github.com/flzara/dotfiles instead**

This repo helps me track and replicate my current and past configuration files.  It's based on [GNU Stow](http://www.gnu.org/software/stow/) to  manage them  and git to track and update them.
It's still missing a lot of them.

## Reminders 

### Installing onto a new system

    $ sudo apt install stow # or any other package manager to install stow
    $ cd $HOME
    $ git clone git@framagit.org:flzara/dotfiles.git .dotfiles
    $ cd .dotfiles
    $ stow bash vim [...] # Any other stow package available in this repo 

## Cookbook Using this repo

## More documentation

- [GNU Stow documentation](http://www.gnu.org/software/stow/manual/stow.html) in one page
- [A quick GNU Stow introduction](http://brandon.invergo.net/news/2012-05-26-using-gnu-stow-to-manage-your-dotfiles.html)
- [Managing strategies with stow](https://taihen.org/managing-dotfiles-with-gnu-stow/)
