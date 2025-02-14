# dotfiles

## Background

I originally set out with the simple approach of [Managing my dotfiles as a git repository](https://drewdevault.com/2019/12/30/dotfiles.html). This concept was stupid simple. Make `$HOME` a git repo, add `*` to the `.gitignore` so your `git status` is clean (no untracked files). Then `git add -f` files you wish to track. No aliases, no bare repo nonsense, just a simple git repo. This worked - very well.

The **ONLY** issue was that my entire `$HOME` directory was a git repo. A `git status` always had something to report. The git information displayed in the shell prompt always indicated I was on master with no changes. Occasionally I might get confused, *wait, is this really a git repo or is this my dotfiles repo... I better `git remote -v` to see what repo I'm actually in.*

Eventually this small issue festered and I started looking closer at the bare repo solutions. On the surface, they seemed more complicated, which is why I avoided them originally. eventually, two things became evident:

1. The initial clone is a bare clone, but we don't work on that bare repo. Immediately after the clone, we checkout a work tree.
1. We instruct git to checkout the work tree to a location *outside* the repo directory!. This is why the alias comes in - to associate the work tree with the git repo. 

So, not so complicated afterall.

## Setup

### Requirements

- curl
- git

### Installation

On a new system run this command in Bash (or Git Bash on Windows):

```bash
curl -Lks https://raw.githubusercontent.com/erniedotson/dotfiles/master/.bin/install.sh | /bin/bash
```

This will attempt to:

- clone the bare repo into `~/.dotfiles`
- checkout the files to `$HOME`
  - If existing dotfiles are found, they will be copied to `~/.dotfiles-backup/`
- update `~/.bashrc` and `~.zshrc` files with `dfgit` alias.

Log out and back in for your new dotfiles to be loaded.

### Tracking dotfiles

The `git` command will not work in your `$HOME` directory because it is not a git repo. An alias saves the day:

`alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

Instead use the alias, `dfgit`, along with any git commands. For example, `git status` becomes `dfgit status`.

## Sharing dotfiles across platforms

### Line Endings

[What is the best git config set up when you are using Linux and Windows?](https://stackoverflow.com/a/6081812)

```bash
git config --system core.autocrlf false
```

## Features

* [DrVanScott/git-clone-init](https://github.com/DrVanScott/git-clone-init) - Automatic setup of user identity (user.email / user.name) on git clone. Just edit `.config/git/templates/git-clone-init`


## References

- [StreakyCobra's response on managing dotfiles | Hacker News](https://news.ycombinator.com/item?id=11070797)
- [The best way to store your dotfiles: A bare Git repository | Atlassian](https://www.atlassian.com/git/tutorials/dotfiles)
- [The Bare Repo Approach to Storing Home Directory Config Files (Dotfiles) in Git using Bash, Zsh, or Powershell | dev.to](https://dev.to/bowmanjd/store-home-directory-config-files-dotfiles-in-git-using-bash-zsh-or-powershell-the-bare-repo-approach-35l3)
