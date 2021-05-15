#!/usr/bin/env bash

DOTFILES_DIR=$(pwd)

link() {
	FILENAME=$1
	TARGET_DIR=$HOME
	if [[ -n $2 ]]; then TARGET_DIR=$2; fi
  if test ! -f "$TARGET_DIR/$FILENAME"; then
    echo "linking $TARGET_DIR/$FILENAME"
    ln -s $DOTFILES_DIR/$FILENAME $TARGET_DIR/$FILENAME
  elif [[ ! -L "$TARGET_DIR/$FILENAME" ]]; then
    echo "replacing $TARGET_DIR/$FILENAME"
    mv -f $TARGET_DIR/$FILENAME $TARGET_DIR/$FILENAME.bak
    ln -s $DOTFILES_DIR/$FILENAME $TARGET_DIR/$FILENAME
	fi
}

link .bash_aliases
link .bashrc
link .tmux.conf.local
link .gitconfig
link .gitignore_global
link .inputrc
link .vimrc
link .wgetrc
[ ! -d $HOME/.config/kitty ] && mkdir -p $HOME/.config/kitty && link kitty.conf $HOME/.config/kitty
[ -d $HOME/.termux ] && link termux.properties $HOME/.termux && wget -O ~/.termux/colors.properties https://raw.githubusercontent.com/dracula/termux/master/colors.properties

