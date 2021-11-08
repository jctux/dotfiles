#!/bin/sh

BACKUPDIR=$HOME/.dotfiles.bak
OMYZSHDIR=$HOME/.oh-my-zsh
TPMDIR=$HOME/.tmux/plugins/tpm
PLATFORM=

if ! which stow >/dev/null 2>&1; then
    echo '"stow" not found, you need to install stow'
    exit 1
fi

mkdir -p $BACKUPDIR
echo "backup in $HOME/..."
for f in $HOME/.zshrc* $HOME/.vim* $HOME/.oh-my-zsh $HOME/.gemrc $HOME/.tmux* $HOME/.zgen*; do
    mv -vf $f $BACKUPDIR/ 2>/dev/null
done
echo ""
echo "vundle..."
git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle


#install oh-my-zsh
git clone https://github.com/robbyrussell/oh-my-zsh.git $OMYZSHDIR
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $OMYZSHDIR/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions $OMYZSHDIR/plugins/zsh-autosuggestions
cp $HOME/dotfiles/zsh/.custom.zsh-theme $HOME/.oh-my-zsh/themes/custom.zsh-theme

#install tpm
echo ""
echo "tpm..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo ""
echo "Restow dotfiles..."
for d in $(find . -maxdepth 1 -path ./.git -prune -o -type d -print  | sed 's|[\./]||g'); do
    stow -R $d
done

rm -fv $HOME/.zcompdump*
echo "installing vim plugins..."
vim +PluginInstall +qall
