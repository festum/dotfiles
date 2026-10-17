# dotfiles

Personal shell, terminal, and editor configuration.

## Install

```sh
git clone git@github.com:festum/dotfiles.git ~/Repo/dotfiles
~/Repo/dotfiles/install.sh
```

The installer links configs into `$HOME` and bootstraps shell plugins. The zsh prompt uses Oh My Zsh's `robbyrussell` theme. Optional Linux fonts: `~/Repo/dotfiles/install-nerdfonts.sh`.

## Local overrides

Use `~/.aliases_local`, `~/.rc_local`, `~/.bashrc_local`, `~/.bash_keys`, `~/.gitconfig-local`, and `~/.gitconfig-github-private` for machine-specific settings. Keep secrets in `~/.bash_keys`.

OMP agent configs live under `.omp/agent` and `.omp/profiles`; do not use `~/.omp/config.yml`. Neovim settings live in `config/nvim/lua/config/` and `config/nvim/lua/plugins/`.
