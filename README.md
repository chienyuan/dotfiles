
# My Dotfile

## Installation

1. clone into the desired location:

```bash
git clone git@github.com:chienyuan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make
```

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
git submodule add git@github.com:moll/vim-bbye.git vim/pack/eric/start/vim-bbye
git submodule add git@github.com:simeji/winresizer.git vim/pack/eric/start/winresizer
git submodule add git@github.com:junegunn/fzf.vim.git  vim/pack/eric/start/fzf
brew install fzf
git commit
```
[submodule "vim/.vim/pack/eric/start/nerdtree"]
	path = vim/.vim/pack/eric/start/nerdtree
	url = git@github.com:preservim/nerdtree.git
[submodule "vim/.vim/pack/eric/start/vim-bbye"]
	path = vim/.vim/pack/eric/start/vim-bbye
	url = git@github.com:moll/vim-bbye.git
[submodule "vim/.vim/pack/eric/start/winresizer"]
	path = vim/.vim/pack/eric/start/winresizer
	url = git@github.com:simeji/winresizer.git
[submodule "vim/.vim/pack/eric/start/fzf"]
	path = vim/.vim/pack/eric/start/fzf
	url = git@github.com:junegunn/fzf.vim.git

get the submodule if you didn't get it yet


```
git submodule update --init
```

updating packages

```
git submodule update 
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



