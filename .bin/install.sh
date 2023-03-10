myrepo_https=https://github.com/erniedotson/dotfiles.git
myrepo_ssh=git@github.com:erniedotson/dotfiles.git
mydir=.dotfiles

# Alias, as it should appear in the file:
#   alias dfgit='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# NOTE: Careful with escape characters in strings below.
myaliasstring="alias dfgit='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'"

function dfgit {
   git --git-dir="${HOME}/${mydir}/" --work-tree="${HOME}" $@
}

# Using https so we can clone and pull anoynymously
git clone --bare "${myrepo_https}" "${HOME}/${mydir}"

# Add SSH remote, set to default push, in case we want to push changes later.
# This will require an SSH public key to be registered with GH.
dfgit remote add origin-ssh ${myrepo_ssh} 
dfgit config remote.pushdefault origin-ssh

# Checkout files, making an attempt to backup conflicted files
mkdir -p ~/.dotfiles-backup
dfgit checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dotfiles.";
    dfgit checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.dotfiles-backup/{}
fi;
dfgit checkout

# Hide untracked files from 'git status'
# dfgit config status.showUntrackedFiles no

# Update profile files
if [ -f ~/.bashrc ]; then
    echo "Adding alias to ~/.bashrc"
    grep -qxF "${myaliasstring}" ~/.bashrc || echo "${myaliasstring}" >> ~/.bashrc
fi
if [ -f ~/.zshrc ]; then
    echo "Adding alias to ~/.zshrc"
    grep -qxF "${myaliasstring}" ~/.zshrc || echo "${myaliasstring}" >> ~/.zshrc
fi
echo "Add the following alias to other shell profile scripts:"
echo "  alias dfgit='git --git-dir=\$HOME/.dotfiles/ --work-tree=\$HOME'"
