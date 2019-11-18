The idea is taken from [here](https://www.atlassian.com/git/tutorials/dotfiles) (also, see the article on how to install your dotfiles onto a new system):


```bash
# create a folder ~/.cfg which is a Git bare repository that will track our files
git init --bare $HOME/.cfg
# create an alias config which we will use instead of the regular git when we want to interact with our configuration repository
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# set a flag - local to the repository - to hide files we are not explicitly tracking yet. This is so that when you type config status and other commands later, files you are not interested in tracking will not show up as untracked
config config --local status.showUntrackedFiles no
# (optional) add the alias definition to your .bashrc
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
```
