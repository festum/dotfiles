# dotfiles

Shell and editor configs. Symlink installer: `install.sh` (not stow/chezmoi/ansible).

## Install

```bash
git clone git@github.com:festum/dotfiles.git ~/Repo/dotfiles
~/Repo/dotfiles/install.sh
```

Needs `bash`/`zsh`, `git`, `ln`, and `curl` or `wget`. Script finds its own directory and exits if those tools are missing. Optional Linux fonts: `~/Repo/dotfiles/install-nerdfonts.sh` (also needs `unzip`, `fc-cache`).

First shell may clone Bash-it or Oh My Zsh + Powerlevel10k. Neovim is [LazyVim](https://github.com/LazyVim/LazyVim) under `config/nvim`; first `nvim` pulls plugins via lazy.nvim.

## Layout

```text
clone → ./install.sh
          ├─ home dots → $HOME/.*
          ├─ config/* → ~/.config/* (OS: config/<name>.{mac|linux|win})
          └─ Termux props if ~/.termux exists

shell → OMZ/Bash-it → ~/.aliases (+ local overlays) → tool inits
```

| Path | Role |
|------|------|
| `install.sh` | Symlinks |
| `install-nerdfonts.sh` | Nerd Fonts → `~/.local/share/fonts` |
| `.aliases` | Shared aliases/helpers |
| `.zshrc` / `.bashrc` | Shell setup |
| `.gitconfig` | Git identity, SSH signing, aliases |
| `config/` | Kitty, Helix, Alacritty (+ mac), Zed, Karabiner, Zellij, LazyVim |

Real files get `*.bak` (timestamped if needed). Wrong/broken symlinks are replaced. Zed is per-file (`-f`) so local-only files stay. Zellij is whole-dir unless local-only files exist. Replacing a real `~/.config/nvim` clears nvim share/state/cache.

Customize Neovim in `config/nvim/lua/config/` and `config/nvim/lua/plugins/`.

## Local overrides

| File | Purpose |
|------|---------|
| `~/.aliases_local` / `~/.aliases.local` | Alias overrides |
| `~/.rc_local` | Shared RC extras |
| `~/.bashrc_local` | Bash-only |
| `~/.bash_keys` | Secrets |
| `~/.p10k.zsh` | Powerlevel10k |
| `~/.gitconfig-local` | Per-machine git |
| `~/.gitconfig-github-private` | Private GitHub (`includeIf`) |

Put `CR_PAT`, `CONTEXT7_API_KEY`, and SSH keys on the host (`sshlo` loads the agent). Default editor is `hx`. No Brewfile or CI; deploy is clone + `install.sh`. Package upgrades: `up`.
