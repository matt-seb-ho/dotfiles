# Template -> `win_vscode` Feature Gaps (Candidate Add-Backs)

Compared:

- `vscode/template.txt` (original template)
- `vscode/win_vscode/keybindings.json` (current Windows config)

This is a **"might be missing"** list from template features that are not currently present in `win_vscode`.

## 1. Likely missing features from template

- [ ] **Window resizing with `Ctrl+Arrow`**
  - `ctrl+up` -> `workbench.action.increaseViewHeight`
  - `ctrl+down` -> `workbench.action.decreaseViewHeight`
  - `ctrl+left` -> `workbench.action.decreaseViewWidth`
  - `ctrl+right` -> `workbench.action.increaseViewWidth`

- [ ] **Suggestion paging in autocomplete popup**
  - `ctrl+d` -> `selectNextPageSuggestion`
  - `ctrl+u` -> `selectPrevPageSuggestion`

- [ ] **Quickfix/search-result jump with bracket keys**
  - `[q` -> `search.action.focusPreviousSearchResult`
  - `]q` -> `search.action.focusNextSearchResult`

- [ ] **Panel list navigation with `Ctrl+j/k` (panel-focused)**
  - `ctrl+j` -> `list.focusDown` when `panelFocus && !terminalFocus`
  - `ctrl+k` -> `list.focusUp` when `panelFocus && !terminalFocus`

- [ ] **Direct focus to editor groups 4 and 5**
  - `ctrl+4` -> `workbench.action.focusFourthEditorGroup`
  - `ctrl+5` -> `workbench.action.focusFifthEditorGroup`

## 2. Notes before re-adding

- Current config already has richer notebook + chat behavior than template; this doc only tracks template features that appear absent.
- `Ctrl+j/k` is already heavily used (splits, quick open, suggestions, explorer). Re-adding panel-focused bindings is possible, but context ordering matters.
- `Ctrl+Arrow` may conflict with OS/window-manager shortcuts on some setups.

## 3. Annotation checklist

Mark what you want me to add:

- [ ] Add **all** missing features above
- [ ] Add only selected items (mark individually)
- [ ] Skip all (keep current `win_vscode` as-is)
