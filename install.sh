#!/usr/bin/env bash

DOTFILES_DIR=$(pwd)

backup() {
  local target_path=$1
  if [[ -e $target_path && ! -L $target_path ]]; then
    mv "$target_path" "${target_path}.bak"
  fi
}

link() {
  local filename=$1
  local target_dir=${2:-$HOME}
  mkdir -p "$target_dir"
  local target_path="$target_dir/$filename"

  if [[ ! -e $target_path ]]; then
    echo "Linking $target_path"
    ln -s "$DOTFILES_DIR/$filename" "$target_path"
  elif [[ ! -L $target_path ]]; then
    echo "Replacing $target_path"
    backup "$target_path"
    ln -s "$DOTFILES_DIR/$filename" "$target_path"
  fi
}

config_link() {
  local name=$1
  local force=$2
  local target_dir="$HOME/.config/$name"
  local src_dir="$DOTFILES_DIR/config/$name"
  local os_suffix

  case "$(uname)" in
    Darwin)
      os_suffix=".mac" ;;
    Linux)
      os_suffix=".linux" ;;
    MINGW* | MSYS* | CYGWIN* | Windows_NT)
      os_suffix=".win" ;;
  esac
  [[ -d "$src_dir$os_suffix" ]] && src_dir="$src_dir$os_suffix"
  [[ -d $target_dir && $force != "-f" ]] && return

  if [[ $force == "-f" ]]; then
    mkdir -p "$target_dir"
    for item in "$src_dir"/*; do
      local base_item=$(basename "$item")
      local target_item="$target_dir/$base_item"
      [[ -L $target_item ]] && continue
      backup "$target_item"
      ln -sf "$item" "$target_item"
    done
  else
    [[ -d $target_dir ]] && return
    ln -s "$src_dir" "$target_dir"
  fi
}

dotfiles=(
  .aliases
  .bashrc
  .zshrc
  .tmux.conf.local
  .gitconfig
  .gitignore_global
  .inputrc
  .vimrc
  .wgetrc
)
for file in "${dotfiles[@]}"; do
  link "$file"
done

config_link kitty
config_link helix
config_link zed -f
config_link alacritty
config_link karabiner

if [[ ! -d $HOME/.config/nvim ]]; then
    echo "Choose NvChad or AstroNvim by entering a, n, or empty to skip"
    read -rp "a/n: " nvim

    case $nvim in
    n)
        echo "Installing NvChad"
        rm -rf $HOME/.local/share/nvim $HOME/.local/state/nvim ~/.cache/nvim
        git clone --depth 1 https://github.com/NvChad/NvChad $HOME/.config/nvim
        rm -rf $HOME/.config/nvim/lua/custom
        ln -s "$DOTFILES_DIR/config/nvim/nvchad/custom" $HOME/.config/nvim/lua
        ;;
    a)
        echo "Installing AstroNvim"
        rm -rf $HOME/.local/share/nvim $HOME/.local/state/nvim $HOME/.cache/nvim
        git clone --depth 1 https://github.com/AstroNvim/AstroNvim $HOME/.config/nvim
        mkdir -p $HOME/.config/astronvim/lua/
        ln -s "$DOTFILES_DIR/config/nvim/astronvim" $HOME/.config/astronvim/lua/user
        ;;
    esac
fi

[ -d $HOME/.termux ] && link termux.properties $HOME/.termux && wget -O ~/.termux/colors.properties https://raw.githubusercontent.com/dracula/termux/master/colors.properties
