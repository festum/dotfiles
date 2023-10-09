#!/usr/bin/env bash

DOTFILES_DIR=$(pwd)

backup() {
  TARGET_PATH=$1
  ([[ -f $TARGET_PATH ]] ||[[ -d $TARGET_PATH ]]) && mv $TARGET_PATH ${TARGET_PATH}.bak
}

link() {
  FILENAME=$1
  TARGET_DIR=$HOME
  if [[ -n $2 ]]; then TARGET_DIR=$2; fi
  if test ! -f "$TARGET_DIR/$FILENAME"; then
    echo "linking $TARGET_DIR/$FILENAME"
    ln -s $DOTFILES_DIR/$FILENAME $TARGET_DIR/$FILENAME
  elif [[ ! -L "$TARGET_DIR/$FILENAME" ]]; then
    echo "replacing $TARGET_DIR/$FILENAME"
    backup $TARGET_DIR/$FILENAME
    ln -s $DOTFILES_DIR/$FILENAME $TARGET_DIR/$FILENAME
  fi
}

link .aliases
link .bashrc
link .zshrc
link .tmux.conf.local
link .gitconfig
link .gitignore_global
link .inputrc
link .vimrc
link .wgetrc
[[ ! -d $HOME/.config/kitty ]] && mkdir -p $HOME/.config/kitty && link kitty.conf $HOME/.config/kitty
[[ ! -d $HOME/.config/helix ]] && mkdir -p $HOME/.config/helix && ln -s $DOTFILES_DIR/helix/config.toml $HOME/.config/helix
echo "Choose NvChad or AstroNvim by enter a or n or empty to skip? (Please remove .config/nvim before this step)"
echo -n "a/n:"
read -r nvim
if [[ $nvim == "n" ]]; then
  [[ ! -d $HOME/.config/nvim ]] && \
  echo "Installing NvChad" && \
  rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ; \
  git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && \
  rm -rf $HOME/.config/nvim/lua/custom && \
  ln -s $DOTFILES_DIR/nvchad/custom $HOME/.config/nvim/lua
elif [[ $nvim == "a" ]]; then
  [[ ! -d $HOME/.config/nvim ]] && \
  rm -rf ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim ; \
  echo "Installing AstroNvim" && \
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
  mkdir -p ~/.config/astronvim/lua/ ; \
  ln -s $DOTFILES_DIR/astronvim ~/.config/astronvim/lua/user
fi

[ -d $HOME/.termux ] && link termux.properties $HOME/.termux && wget -O ~/.termux/colors.properties https://raw.githubusercontent.com/dracula/termux/master/colors.properties
