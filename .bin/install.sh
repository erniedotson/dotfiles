#!/bin/bash
set -uo pipefail
IFS=$'\n\t'

myrepo_https=https://github.com/erniedotson/dotfiles.git
myrepo_ssh=git@github.com:erniedotson/dotfiles.git
mydir=.dotfiles

function dfgit {
    git --git-dir="${HOME}/${mydir}" --work-tree="${HOME}" $@
}

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  if [[ "$HOME" != "$USERPROFILE"]]; then
    printf "\nWARNING: Variables HOME [$HOME] and USERPROFILE [$USERPROFILE] differ. Setting HOME to USERPROFILE.\n"
    HOME="$USERPROFILE"
  fi
fi

# Using https so we can clone and pull anoynymously
printf "\nCloning repo...\n"
git clone --bare "${myrepo_https}" "${HOME}/${mydir}" || exit 1

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
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  printf "\nUpdating windows profile...\n"
  cmd.exe /C "$HOME/.alises.cmd" "-i"
fi

# Alias, as it should appear in the file:
#   alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# NOTE: Careful with escape characters in strings below.
myaliasstring="alias dfgit='git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME'"

printf "\nOptional: Add the following alias to your shell profile rc scripts:\n"
printf "  ${myaliasstring}\n\n"
