# VSCode Configuration

Cross-platform VSCode setup built around a **VSCodeVim** workflow. The guiding
idea (see [`keybind-strategy.md`](./keybind-strategy.md)) is to split the config
into two layers:

- **Vim leader/motion layer** — modifier-free (`<space>ff`, `gd`, `ciw`,
  `[d`/`]d`). Identical on every OS, so it lives once in `settings.json`.
- **Native chord layer** — heavy modifier use (`Ctrl+P`, `Cmd+B`, window nav).
  This is the only part that diverges per OS, so it lives in per-OS
  `keybindings.json` files.

Everything is meant to be propagated via VSCode **Settings Sync**; the per-OS
folders exist so you can drop the right `keybindings.json` onto each machine.

## Layout

```
vscode/
├── README.md                     ← you are here
├── keybind-strategy.md           ← cross-OS keybind philosophy (Mac/Linux/Win)
├── notebook-binds-strategy.md    ← Jupyter notebook Vim two-mode design
├── settings.json                 ← canonical/shared settings (Windows-host flavor)
├── keybindings.json              ← canonical/shared chord layer reference
├── template.txt                  ← upstream gist the configs were derived from
├── mac_vscode/                   ← macOS host (Cmd-based chords)
│   ├── settings.json
│   └── keybindings.json
├── linux_vscode/                 ← native Linux host (Ctrl-based chords, fish)
│   ├── settings.json
│   └── keybindings.json
└── win_vscode/                   ← Windows host / Remote-SSH into Linux
    ├── settings.json
    └── keybindings.json
```

### What's what

| File | Purpose |
|---|---|
| `keybind-strategy.md` | Why the leader layer is OS-agnostic, scan-codes vs `oem_*`, VSCodeVim vs vscode-neovim, the Cmd-vs-Ctrl problem, Obsidian/tmux notes. Read this first. |
| `notebook-binds-strategy.md` | The two-mode Jupyter model: cell **edit mode** (a cell is a normal Vim buffer) ⇄ cell **list mode** (navigate / delete / copy / move cells with Vim binds). Explains the `when`-clause vocabulary and the Esc/Shift+Esc transition. |
| `vim-keybinds-guide.md` | Practical quick-reference for the final setup: key settings, core binds, notebook binds, and chat-pane-safe behavior. |
| `*/settings.json` | Workbench, theme, Vim leader bindings, terminal profile, Remote-SSH, Copilot toggles. The leader-layer bindings here are the same across OSes. |
| `*/keybindings.json` | The native chord layer + the notebook cell-list/edit-mode bindings. This is the file that differs per OS. |

### Per-OS differences (chord layer)

- **`mac_vscode/`** — uses `Cmd` for the command modifier (`cmd+p`, `cmd+k b`).
  This is the oldest variant; notebook cell-list keys are uppercase (`I`/`J`/`K`).
- **`linux_vscode/`** — `Ctrl` is the native modifier (same family as Windows).
  Default integrated terminal is **fish**. No Windows-only keys
  (`remote.SSH.useLocalServer`, PowerShell profiles).
- **`win_vscode/`** — `Ctrl`-based, tuned for a locked-down Windows box that
  **Remote-SSHes into Linux**: forces `remote.SSH.useLocalServer: false` and
  defines both PowerShell and fish (remote) terminal profiles.

`linux_vscode` and `win_vscode` keybindings are nearly identical because `Ctrl`
is the command modifier on both; the Linux variant just drops the
Windows-specific commentary and adds cell-move binds.

## Install

VSCode reads user config from:

| OS | Path |
|---|---|
| macOS | `~/Library/Application Support/Code/User/` |
| Linux | `~/.config/Code/User/` |
| Windows | `%APPDATA%\Code\User\` |

Copy or symlink the matching folder's files into that directory, e.g. on Linux:

```bash
ln -sf "$PWD/linux_vscode/settings.json"    ~/.config/Code/User/settings.json
ln -sf "$PWD/linux_vscode/keybindings.json" ~/.config/Code/User/keybindings.json
```

(Use the VSCodeVim extension; the leader bindings in `settings.json` depend on
it.) The strategy docs are reference material and are not loaded by VSCode.
