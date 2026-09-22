# VSCode Vim Keybinds Guide

This is the practical reference for the config in this folder.

## 1. Core model

1. **`settings.json` = Vim leader layer** (`<space>...`) and shared editor/workbench settings.
2. **`keybindings.json` = chord layer** (Ctrl/Cmd/Alt/Shift combos), notebook layer, panel/list navigation.
3. **Per-OS folders** (`mac_vscode`, `linux_vscode`, `win_vscode`) keep native chord differences while preserving the same Vim mental model.

## 2. Important settings (all OS)

- `vim.leader` is `<space>`.
- `editor.lineNumbers` is relative.
- `workbench.activityBar.location` is hidden.
- `notebook.lineNumbers` is on.
- Integrated terminal defaults to fish on Linux/remote Linux.

## 3. Core non-notebook keybinds

| Intent | Binding | Notes |
|---|---|---|
| Focus split left/right/down/up | `Ctrl+h/l/j/k` | Active in Vim non-insert mode; guarded from terminal and suggestion collisions |
| Previous/next editor | `H` / `L` | Now guarded by `!inputFocus` so typing in chat input does not switch editors |
| Previous/next editor (alt form) | `[b` / `]b` | Scan-code based bracket binds |
| Diagnostics | `[d` / `]d`, `[e` / `]e` | Files-wide and current-file marker navigation |
| Git hunk navigation | `[h` / `]h` | Previous/next change |
| Move line | `Alt+j` / `Alt+k` | Editor text focus only |
| Toggle terminal | `Ctrl+/` (Win/Linux), `Cmd+/` (Mac) | Editor-focused toggle |
| Toggle editor ↔ terminal focus | `Ctrl+;` | Bidirectional focus jump |

## 4. Notebook Vim layer (all OS)

Notebook has two states:

1. **Cell edit mode** (`inputFocus`) — VSCodeVim behaves like normal editing.
2. **Cell-list mode** (`notebookEditorFocused && !inputFocus`) — Vim-like whole-cell ops.

### Mode transitions

- `Esc` stays with Vim (exit insert -> normal).
- `Shift+Esc` exits cell edit back to list mode.
- `i` or `Enter` enters edit mode for selected cell.

### Cell-list mode keys

| Action | Binding |
|---|---|
| Move selected cell cursor | `j` / `k`, `gg`, `G` |
| Delete cell | `dd` |
| Copy cell | `y` or `yy` |
| Cut / paste | `x` / `p` |
| Insert below/above | `o` / `O` |
| Undo | `u` |
| Extend multi-cell selection | `Shift+j` / `Shift+k` |
| Move selected cell(s) | `Alt+j` / `Alt+k` |
| Run cell | `Ctrl+Enter` (Win/Linux), `Cmd+Enter` (Mac) |
| Run and select below | `Shift+Enter` |

## 5. Chat-pane-safe behavior

The biggest fix is preventing navigation binds from triggering while typing into Copilot chat input.

- `H` / `L` editor-tab bindings now require `!inputFocus`.
- Added explicit chat navigation:
  - `Ctrl+w c` -> open/focus chat
  - `Ctrl+w e` -> return focus to active editor group

This keeps chat typing safe while preserving Vim-like panel movement.

## 6. Which files to install on each OS

- **macOS:** `mac_vscode/settings.json`, `mac_vscode/keybindings.json`
- **Linux:** `linux_vscode/settings.json`, `linux_vscode/keybindings.json`
- **Windows:** `win_vscode/settings.json`, `win_vscode/keybindings.json`

## 7. Useful extra binds worth knowing

These are easy to miss if you're coming from long-term custom VSCode habits.

| Area | Binding | Behavior |
|---|---|---|
| Quick Open list nav | `Tab`, `Ctrl+Tab`, `Ctrl+j`, `Ctrl+k` | Move through file results in Quick Open |
| Suggestion popup nav | `Ctrl+j` / `Ctrl+k`, `Tab` / `Shift+Tab` | Navigate completion popup items |
| File explorer nav | `Ctrl+j/k/h/l` | Down/up/collapse/select in explorer tree |
| Generic list nav | `j` / `k` | Vim-style up/down in list UIs (search, problems, etc.) |
| Editor groups | `Ctrl+1/2/3` (or `Cmd+1/2/3` on Mac) | Jump to editor group by index |
| Notebook leader in cell-list mode | `Space f`, `Space b`, `Space B` | Quick open and editor list actions without leaving notebook list mode |

### Defaults still in effect (not custom-bound here)

- **Accept popup completion:** VSCode default (typically `Enter`).
- **Copilot inline/ghost-text accept/next/prev:** VSCode/Copilot defaults (no explicit custom inline-suggestion keybinds are defined in this repo yet).
