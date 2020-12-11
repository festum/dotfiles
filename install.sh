#!/usr/bin/env bash

DOTFILES_DIR=$(pwd)

link() {
	FILENAME=$1
	TARGET_DIR=$HOME
	if [[ -n $2 ]]; then TARGET_DIR=$2; fi
    if test ! -f "$TARGET_DIR/$FILENAME"; then
		echo "linking to $TARGET_DIR/$FILENAME"
		ln -s $DOTFILES_DIR/$FILENAME $TARGET_DIR/$FILENAME
	fi
}

link .bash_aliases
link .bashrc
link .tmux.conf.local
link .gitconfig
link .gitignore_global
link .inputrc
link .wgetrc
[ ! -d $HOME/.config/kitty ] && mkdir -p $HOME/.config/kitty
link kitty.conf $HOME/.config/kitty
