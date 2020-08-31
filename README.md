
# My Dotfile

## .bashrc and .gitconfig

```bash
mv $HOME/.bashrc $HOME/.bashrc.save
ln -s dotfiles/bashrc $HOME/.bashrc
ln -s dotfiles/gitconfig $HOME/.gitconfig
```
dotfiles/bashrc call dotfiles/gitrc for git prompt

## vim-packages

```
cd ~/dotfiles
git submodule init
git submodule add git@github.com:preservim/nerdtree.git vim/pack/eric/start/nerdtree
git add .gitmodules vim/pack/eric/start/nerdtree
git commit
```

updating packages

```
git submodule update --remote --merge
git commit
```

removing a package

```
git submodule deinit vim/pack/eric/start/nerdtree
git rm vim/pack/eric/start/nerdtree
rm -Rf .git/modules/vim/pack/eric/start/nerdtree
git commit
```



