myrepo=git@github.com:erniedotson/dotfiles.git
mydir=.dotfiles

git clone --bare "${myrepo}" "${HOME}"/${mydir}
function dfgit {
   /usr/bin/git --git-dir=${HOME}/${mydir}/ --work-tree=${HOME} $@
}
mkdir -p .dotfiles-backup
dfgit checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dotfiles.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dfgit checkout
# dfgit config status.showUntrackedFiles no
