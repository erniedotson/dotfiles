#!/bin/bash
set -uo pipefail
IFS=$'\n\t'

myrepo_https=https://github.com/erniedotson/dotfiles.git
myrepo_ssh=git@github.com:erniedotson/dotfiles.git
mydir=.dotfiles
need_git_dir=false

function dfgit {
  if [[ "${need_git_dir}" = true ]]; then
    git --git-dir="${HOME}/${mydir}/.git" --work-tree="${HOME}" $@
  else
    git --git-dir="${HOME}/${mydir}" --work-tree="${HOME}" $@
  fi
}

# Using https so we can clone and pull anoynymously
printf "\nCloning repo...\n"
git clone --bare "${myrepo_https}" "${HOME}/${mydir}" || exit 1

# Test if we need to include the .git dir in --git-dir.
git --git-dir="${HOME}/${mydir}/.git" --work-tree="${HOME}" status > /dev/null 2>&1 && need_git_dir=true || need_git_dir=false

# Add SSH remote, set to default push, in case we want to push changes later.
# This will require an SSH public key to be registered with GH.
printf "\nConfiguring repo...\n"
dfgit remote add origin-ssh ${myrepo_ssh} || exit 1
dfgit config remote.pushdefault origin-ssh || exit 1

# Checkout files, making an attempt to backup conflicted files
printf "\nChecking out files...\n"
mkdir -p ~/.dotfiles-backup

if dfgit checkout ; then
  printf "\nChecked out dotfiles.\n";
else
  printf "\nCheckout failed due to conflicts. Backing up pre-existing dotfiles...\n";
  dfgit checkout 2>&1 | egrep "^\s+" | awk {'print $1'} | xargs sh -c 'for arg do echo "Moving $arg..."; mkdir -p ~/.dotfiles-backup/$(dirname $arg); mv ~/$arg ~/.dotfiles-backup/$(dirname $arg)/$(basename $arg); done' _
  printf "\nChecking out files once more...\n"
  dfgit checkout || exit 1
fi;

# Hide untracked files from 'git status'
# dfgit config status.showUntrackedFiles no

# Update profile files

if [[ "${need_git_dir}" = true ]]; then
  # Alias, as it should appear in the file:
  #   alias dfgit='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
  # NOTE: Careful with escape characters in strings below.
  myaliasstring="alias dfgit='git --git-dir=\$HOME/.dotfiles/.git --work-tree=\$HOME'"
else
  # Alias, as it should appear in the file:
  #   alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
  # NOTE: Careful with escape characters in strings below.
  myaliasstring="alias dfgit='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'"
fi

if [ -f ~/.bashrc ]; then
  printf "\nAdding alias to ~/.bashrc ...\n"
  grep -qxF "${myaliasstring}" ~/.bashrc || echo "${myaliasstring}" >> ~/.bashrc
fi
if [ -f ~/.zshrc ]; then
  printf "\nAdding alias to ~/.zshrc ...\n"
  grep -qxF "${myaliasstring}" ~/.zshrc || echo "${myaliasstring}" >> ~/.zshrc
fi
printf "\nOptional: Add the following alias to other shell profile scripts:\n"
printf "  ${myaliasstring}\n\n"
