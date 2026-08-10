#!/usr/bin/env bash
set -euo pipefail

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

require_cmd mkdir unzip find rm fc-cache
require_download

declare -a fonts=(
  AnonymousPro
  FiraCode
  Hack
  InconsolataGo
  NerdFontsSymbolsOnly
  UbuntuMono
)

fonts_dir="${HOME}/.local/share/fonts"
mkdir -p "$fonts_dir"

for font in "${fonts[@]}"; do
  zip_file="${font}.zip"
  download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${zip_file}"
  echo "Downloading $download_url"
  download "$download_url" "/tmp/$zip_file"
  unzip -o "/tmp/$zip_file" -d "$fonts_dir" -x "*.otf" -x "*.txt" -x "*.md" -x "LICENSE"
  rm -f "/tmp/$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
