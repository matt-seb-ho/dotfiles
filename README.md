# Dotfiles

This repo keeps configuration for the machines I actually use, plus older
editor setups that may be useful again later.

The layout has two dimensions:

- `common/` contains application config that can be shared across machines.
- `machines/<name>/` contains OS- or hardware-specific config.
- `archive/` contains configs I do not use now but want to keep.

The application is the directory inside each of those areas. For example,
`machines/macbook/kitty/` is the Kitty config for the MacBook, while
`common/tmux/` is the shared tmux config.

## Machines

### MacBook

The MacBook is the current daily driver. Its active application configs are
under `machines/macbook/`:

- `kitty/` for Kitty, its Rosé Pine Dawn theme, and helper scripts.
- `sioyek/` for the PDF reader.
- `vscode/` for the live VS Code settings and keybindings.
- `browser/` for browser extension exports and LeechBlock settings.
- `activitywatch/` for the themed ActivityWatch web UI and category export.

The shared active configs are:

- `common/tmux/.tmux.conf`
- `common/vim/.vimrc`
- `common/fzf/default_opts.txt`
- `common/keyd/` for the Linux keyd mappings used by the Sway machines.
- `common/themes.yaml`

The MacBook copies were refreshed from the live files at these paths:

| Application | Live path | Repo path |
| --- | --- | --- |
| tmux | `~/.tmux.conf` | `common/tmux/.tmux.conf` |
| Vim | `~/.vimrc` | `common/vim/.vimrc` |
| Kitty | `~/.config/kitty/` | `machines/macbook/kitty/` |
| Sioyek | `~/.config/sioyek/` | `machines/macbook/sioyek/` |
| VS Code | `~/Library/Application Support/Code/User/` | `machines/macbook/vscode/` |

Sioyek checks more than one directory on macOS. The custom `keys_user.config`
and `prefs_user.config` were found under `~/.config/sioyek/`; the files under
`~/Library/Application Support/sioyek/` are app state and are not tracked.

### ThinkPad

`machines/thinkpad/sway/` contains the current Sway config and the status-bar
script. The config keeps ThinkPad-specific battery, volume, wallpaper, and
input behavior together.

### Jagaimo

`machines/jagaimo/` contains Jagaimo's Linux setup:

- Kitty
- Sioyek
- Sway
- Swaylock
- SwayNC
- Fuzzel

### Windows

Windows is represented now. `machines/windows/komorebi/` contains the
Komorebi and whkd setup. The cross-platform VS Code notes and OS-specific
variants live in `common/vscode/`, including `mac_vscode/`, `linux_vscode/`,
and `win_vscode/`.

## Archived editors

I no longer use Helix, Alacritty, or Neovim as primary tools. Their configs
are kept under `archive/editors/` and were refreshed from the current MacBook
files where those files still exist:

- `archive/editors/helix/`
- `archive/editors/alacritty/`
- `archive/editors/neovim/`
- `archive/editors/lvim/`

The older tmux alternatives are in `archive/alternatives/tmux/`. Archived
files are not part of the active MacBook setup.

## Vim and tmux notes

Vim uses vim-plug. Install it with:

```sh
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

Then run `:PlugInstall` inside Vim.

The current Vim leader is Space. tmux uses the backtick as its prefix, and
its active config uses TPM. The old Nvim navigation notes remain in the
archived configuration rather than describing the active setup.

## Themes

[`common/themes.yaml`](common/themes.yaml) is the palette reference for Rosé
Pine, Gruvbox, Everforest, Kanagawa, and Catppuccin. The current default is
Rosé Pine Dawn.
