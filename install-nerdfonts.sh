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

require_cmd mkdir mktemp mv unzip find fc-cache
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
# fontconfig only loads .conf files from its conf.d directories, not from font dirs.
conf_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/fontconfig/conf.d"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$fonts_dir" "$conf_dir"

for font in "${fonts[@]}"; do
  echo "Installing $font"
  zip_file="${tmp_dir}/${font}.zip"
  download_url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
  download "$download_url" "$zip_file"
  # Extract only what belongs in the font dir. Exit 11 means a pattern had no
  # match in this archive (e.g. no .otf or .conf), which is expected.
  rc=0
  unzip -oq "$zip_file" -d "$fonts_dir" '*.ttf' '*.otf' '*.conf' 2>"${tmp_dir}/unzip.err" || rc=$?
  if [[ $rc -ne 0 && $rc -ne 11 ]]; then
    cat "${tmp_dir}/unzip.err" >&2
    exit 1
  fi
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

for conf in "$fonts_dir"/*.conf; do
  [[ -e $conf ]] || continue
  mv -f "$conf" "$conf_dir/"
done

fc-cache -f "$fonts_dir"
echo "Nerd Fonts installed in $fonts_dir"
