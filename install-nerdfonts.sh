#!/bin/bash

declare -a fonts=(
  AnonymousPro
	FiraCode
	Hack
	InconsolataGo
	NerdFontsSymbolsOnly
	UbuntuMono
)

version='3.0.2'
fonts_dir="${HOME}/.local/share/fonts"

if [[ ! -d "$fonts_dir" ]]; then
    mkdir -p "$fonts_dir"
fi

for font in "${fonts[@]}"; do
    zip_file="${font}.zip"
    download_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${version}/${zip_file}"
    echo "Downloading $download_url"
  	wget -q "$download_url" -O /tmp/$zip_file
    unzip -o "/tmp/$zip_file" -d "$fonts_dir" -x "*.otf" -x "*.txt" -x "*.md" -x "LICENSE"
    rm -f "/tmp/$zip_file"
done

find "$fonts_dir" -name '*Windows Compatible*' -delete

fc-cache -fv
