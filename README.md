
# My Dotfile

The .bash_profile call .bashrc
```bash
mv $HOME/.bashrc $HOME/.bashrc.save
ln -s dotfiles/bashrc $HOME/.bashrc
ln -s dotfiles/gitconfig $HOME/.gitconfig
```
dotfiles/bashrc call dotfiles/gitrc for git prompt

install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

run :PlugInstall

coc plugin need node
Install nodejs >= 10.12
```
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs
```
