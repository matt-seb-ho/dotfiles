# Original -> New VSCode Vim Binds: Gap Notes

This compares:

- **Original:** `original_dotfiles/vscode/keybindings.json` + `original_dotfiles/vscode/settings.json`
- **New target:** `vscode/mac_vscode/keybindings.json` + `vscode/mac_vscode/settings.json`

`settings.json` is effectively unchanged between original and new. The migration differences are almost entirely in `keybindings.json`.

## What changed that you will feel immediately

| Area | Original habit | New behavior | Possible "missing" feeling |
|---|---|---|---|
| Notebook cell-list keys | Uppercase: `I`, `J`, `K`, `D D`, `Y`, `X`, `P`, `U` | Lowercase Vim-like: `i`, `j`, `k`, `dd`, `y`, `x`, `p`, `u` | Muscle memory mismatch in notebooks until retrained |
| Notebook run key on Mac | `ctrl+enter` was bound | `cmd+enter` is the run key on Mac config | You may reach for `ctrl+enter` and nothing happens |
| Editor list shortcuts | `cmd+k b` and `cmd+k shift+b` custom binds were present | Not present as direct cmd-chords; use leader (`<space>b`, `<space>B`) and notebook-scoped `<space>b/<space>B` | If you rely on `cmd+k b`, it will feel missing |
| Quick open override | Explicit `cmd+p` entries were present (including a disable line) | No explicit custom `cmd+p` entry in new file | Behavior now relies on VSCode defaults + leader flow |
| Chat safety | No chat-aware guarding | `H/L` tab switching now blocked while typing in inputs; chat open/return binds added (`ctrl+w c`, `ctrl+w e`) | If you used `H/L` in non-editor contexts, it now behaves more strictly |

## New capabilities added (not in original)

| Area | New binds |
|---|---|
| Notebook mode entry | `enter` also enters cell edit mode (in addition to `i`) |
| Notebook copy alias | `yy` copies cells (alongside `y`) |
| Notebook multi-cell selection | `shift+j` / `shift+k` |
| Notebook move cells | `alt+j` / `alt+k` |
| Split navigation | `ctrl+h/j/k/l` for editor groups (with guards) |
| Bracket-style nav | `[b` `]b`, `[d` `]d`, `[e` `]e`, `[h` `]h` |
| Terminal focus toggle | `ctrl+;` editor <-> terminal |
| Chat navigation | `ctrl+w c` open chat, `ctrl+w e` return to editor |

## Things from original that are intentionally not carried over

1. `cmd+k b` and `cmd+k shift+b` direct binds in keybindings (replaced by leader-oriented workflow).
2. Explicit `cmd+p` override/unset entries.
3. `alt+cmd+tab` unbind for `showAllEditors`.
4. `ctrl+\`` unbind entry for terminal toggle.
5. Uppercase-only notebook operations (moved to lowercase Vim-like notebook layer).

## Annotation checklist (mark what you want added back)

- [ ] Add back `cmd+k b` -> `workbench.action.showEditorsInActiveGroup`
- [ ] Add back `cmd+k shift+b` -> `workbench.action.showAllEditors`
- [ ] Add `ctrl+enter` as an additional notebook run key on Mac
- [ ] Restore any `cmd+p` custom behavior from original
- [ ] Keep uppercase notebook aliases (`I/J/K/...`) in parallel with lowercase
- [ ] Remove/modify chat binds (`ctrl+w c`, `ctrl+w e`)
- [ ] Keep everything as-is (no add-backs)

