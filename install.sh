#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

require_cmd() {
  local cmd
  for cmd in "$@"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "error: required command not found: $cmd" >&2
      exit 1
    fi
  done
}

require_download() {
  if command -v curl >/dev/null 2>&1; then
    DOWNLOAD_CMD=curl
  elif command -v wget >/dev/null 2>&1; then
    DOWNLOAD_CMD=wget
  else
    echo "error: required command not found: curl or wget" >&2
    exit 1
  fi
}

download() {
  local url=$1
  local dest=$2
  case "$DOWNLOAD_CMD" in
    curl) curl -fsSL "$url" -o "$dest" ;;
    wget) wget -q "$url" -O "$dest" ;;
  esac
}

require_cmd ln mkdir mv uname basename git readlink rm find
require_download

# True if path is a symlink pointing exactly at expected (absolute) source.
is_link_to() {
  local target_path=$1
  local expected=$2
  [[ -L $target_path ]] && [[ $(readlink "$target_path") == "$expected" ]]
}

# Move aside a real file/dir. Symlinks are removed, not backed up.
backup() {
  local target_path=$1
  if [[ -L $target_path ]]; then
    rm "$target_path"
  elif [[ -e $target_path ]]; then
    local bak="${target_path}.bak"
    if [[ -e $bak || -L $bak ]]; then
      bak="${target_path}.bak.$(date +%s)"
    fi
    mv "$target_path" "$bak"
  fi
}

# Ensure target_path is a symlink to source_path (idempotent).
ensure_link() {
  local source_path=$1
  local target_path=$2

  if is_link_to "$target_path" "$source_path"; then
    return 0
  fi

  if [[ -L $target_path ]]; then
    echo "Updating $target_path"
    rm "$target_path"
  elif [[ -e $target_path ]]; then
    echo "Replacing $target_path"
    backup "$target_path"
  else
    echo "Linking $target_path"
  fi

  ln -s "$source_path" "$target_path"
}

link() {
  local filename=$1
  local target_dir=${2:-$HOME}
  local source_path="$DOTFILES_DIR/$filename"
  local target_path="$target_dir/$filename"

  if [[ ! -e $source_path ]]; then
    echo "error: source not found: $source_path" >&2
    exit 1
  fi

  mkdir -p "$(dirname "$target_path")"
  ensure_link "$source_path" "$target_path"
}

resolve_config_src() {
  local name=$1
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
  printf '%s\n' "$src_dir"
}

# 0 if target is missing, already a symlink, or every top-level entry exists in src.
config_dir_is_repo_only() {
  local target_dir=$1
  local src_dir=$2
  local item base

  if [[ ! -e $target_dir || -L $target_dir ]]; then
    return 0
  fi

  while IFS= read -r -d '' item; do
    base=$(basename "$item")
    if [[ ! -e $src_dir/$base && ! -L $src_dir/$base ]]; then
      return 1
    fi
  done < <(find "$target_dir" -mindepth 1 -maxdepth 1 -print0)

  return 0
}

config_link() {
  local name=$1
  local force=${2:-}
  local target_dir="$HOME/.config/$name"
  local src_dir

  src_dir=$(resolve_config_src "$name")

  if [[ ! -d $src_dir ]]; then
    echo "error: config source not found: $src_dir" >&2
    exit 1
  fi

  if [[ $force == "-f" ]]; then
    # Parent must be a real directory (not a symlink to a whole package tree).
    if [[ -L $target_dir ]]; then
      echo "Replacing symlink $target_dir with directory for force-link"
      rm "$target_dir"
    fi
    mkdir -p "$target_dir"
    local item base_item target_item
    for item in "$src_dir"/*; do
      [[ -e $item ]] || continue
      base_item=$(basename "$item")
      target_item="$target_dir/$base_item"
      ensure_link "$item" "$target_item"
    done
  else
    ensure_link "$src_dir" "$target_dir"
  fi
}

# Whole-dir link when live config has no local-only entries; otherwise -f.
config_link_auto() {
  local name=$1
  local target_dir="$HOME/.config/$name"
  local src_dir

  src_dir=$(resolve_config_src "$name")
  if config_dir_is_repo_only "$target_dir" "$src_dir"; then
    config_link "$name"
  else
    echo "Local-only files under $target_dir; force-linking repo entries"
    config_link "$name" -f
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
  .opencommit
  .omp/agent/config.yml
  .omp/agent/models.yml
  .omp/agent/extensions/hindsight-bridge.ts
)
for file in "${dotfiles[@]}"; do
  link "$file"
done

config_link kitty
config_link helix
config_link zed -f
config_link alacritty
config_link karabiner
config_link_auto zellij

# LazyVim: https://github.com/LazyVim/starter (imports LazyVim/LazyVim)
nvim_src="$DOTFILES_DIR/config/nvim"
nvim_dst="$HOME/.config/nvim"
if ! is_link_to "$nvim_dst" "$nvim_src"; then
  if [[ -e $nvim_dst || -L $nvim_dst ]]; then
    echo "Replacing existing Neovim config with LazyVim"
    rm -rf "$HOME/.local/share/nvim" "$HOME/.local/state/nvim" "$HOME/.cache/nvim"
  fi
fi
config_link nvim

if [[ -d $HOME/.termux ]]; then
  link termux.properties "$HOME/.termux"
  download \
    https://raw.githubusercontent.com/dracula/termux/master/colors.properties \
    "$HOME/.termux/colors.properties"
fi
