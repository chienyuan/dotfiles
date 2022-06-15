
# My Dotfile

## Installation

1. clone into the desired location:

```bash
git clone git@github.com:chienyuan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
sudo apt update
sudo apt install build-essential
make
git submodule update --init
git submodule update
ps. because we update all those submodule url with https version. you need to do "git submodule sync" to update it in .git/config 
```

Error
=====
stow -t /home/prince runcom
WARNING! stowing runcom would cause conflicts:                                                                                          │····
  * existing target is not owned by stow: .bashrc
Ans: unlink previous dot file , ex .bashrc -> dotfiles/bashrc

## vim-packages

```
cd ~/dotfiles
git submodule init
git submodule add https://github.com/preservim/nerdtree.git vim/.vim/pack/eric/start/nerdtree
git submodule add https://github.com/moll/vim-bbye.git      vim/.vim/pack/eric/start/vim-bbye
git submodule add https://github.com/simeji/winresizer.git  vim/.vim/pack/eric/start/winresizer
git submodule add https://github.com/junegunn/fzf.vim.git   vim/.vim/pack/eric/start/fzf
git submodule add https://github.com/hwayne/tla.vim.git     vim/.vim/pack/eric/start/tla
git submodule add https://github.com/tomtom/tlib_vim.git vim/.vim/pack/eric/start/tlib_vim
git submodule add https://github.com/MarcWeber/vim-addon-mw-utils.git vim/.vim/pack/eric/start/vim-addon-mw-utils
git submodule add https://github.com/garbas/vim-snipmate.git vim/.vim/pack/eric/start/vim-snipmate
git submodule add https://github.com/honza/vim-snippets.git vim/.vim/pack/eric/start/vim-snippets
git submodule add https://github.com/hwayne/tla.vim.git vim/.vim/pack/eric/start/tla.vim
git submodule add https://github.com/itchyny/lightline.vim.git vim/.vim/pack/eric/start/lightline
sudo apt install fzf
brew install fzf
git commit
```

get the submodule if you didn't get it yet

## .bashrc and .gitconfig

```bash
mv $HOME/.bashrc $HOME/.bashrc.save
ln -s dotfiles/bashrc $HOME/.bashrc
ln -s dotfiles/gitconfig $HOME/.gitconfig
```
dotfiles/bashrc call dotfiles/gitrc for git prompt

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



