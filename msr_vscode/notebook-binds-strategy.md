# VSCode Notebook Vim-Bind Strategy

Context: Jupyter notebooks in VSCode, controlled with VSCodeVim. The goal is a
Neovim-like workflow: edit the focused cell as a normal Vim buffer, then pop back
out to a notebook-level cell list where Vim-shaped keys manipulate whole cells.

---

## 1. The core mental model: two layers

| Layer | VSCode focus state | What keys mean |
|---|---|---|
| **Cell edit mode** | Focus is inside a cell editor | VSCodeVim owns insert/normal/visual mode, motions, operators |
| **Cell-list mode** | Notebook focused, no text input focused | Bare keys act on whole cells: `j`, `k`, `dd`, `y`, `p`, `o` |

The Neovim analogy:

1. **Inside a cell**, the cell is just a Vim buffer. `Esc` leaves Insert mode and
   lands in Vim Normal mode inside that same cell. Motions, text objects,
   operators, visual mode, and leader mappings are owned by VSCodeVim.
2. **Outside the cell editor**, the selected cell is the cursor. `j`/`k` move the
   selection, `dd` deletes, `y` copies, `p` pastes, `o` inserts below, and `i` or
   `Enter` enters the selected cell.

Cell-list mode is not a replacement for VSCodeVim. It is the notebook-level
layer above VSCodeVim.

---

## 2. The `when`-clause vocabulary

VSCode makes this work by letting the same key mean different things in different
contexts.

| Context key | Meaning | Why it matters |
|---|---|---|
| `notebookEditorFocused` | A notebook editor has focus somewhere | Broad guard for notebook-only bindings |
| `inputFocus` | Some text/input widget is focused | True inside a cell editor; false in the cell list |
| `notebookCellListFocused` | The notebook cell container/list is focused | Useful for execution and default notebook commands |
| `editorTextFocus` | A text editor has focus | True while editing a code/markdown cell |
| `vim.active` | VSCodeVim is active in the focused editor | Keeps Vim-specific overrides scoped to Vim |
| `vim.mode == 'Normal'` | VSCodeVim is currently in Normal mode | Useful after Vim has consumed the first `Esc` |
| `listFocus` | Some VSCode list/tree has focus | Useful for generic `list.*` commands |

The key signal for cell-list mode is:

```text
notebookEditorFocused && !inputFocus
```

Read it as: "we are in a notebook, but not inside a text input." That is exactly
the notebook-level list layer. `notebookCellListFocused` is useful too, but this
is the clean mental-model guard used by the polished Windows config. Use
`listFocus` only when the command really needs a VSCode list/container, such as
the current `o` binding.

---

## 3. Mode transitions: Esc belongs to Vim first

Desired behavior:

1. While typing in a cell, press `Esc` once.
2. VSCodeVim exits Insert mode and lands in Vim Normal mode inside the cell.
3. Press `Shift+Esc` to leave the cell editor and return to cell-list mode.

So the first `Esc` is a Vim key. Leaving the cell is a second deliberate action.
The current Windows config implements that with this pair:

```jsonc
{
  "key": "shift+escape",
  "command": "notebook.cell.quitEdit",
  "when": "inputFocus && notebookEditorFocused && !editorHasMultipleSelections && !editorHasSelection && !editorHoverVisible"
},
{
  "key": "escape",
  "command": "-notebook.cell.quitEdit",
  "when": "inputFocus && notebookEditorFocused && vim.active && !editorHasSelection && !editorHoverVisible && vim.mode == 'Normal'"
}
```

Read this as: `Esc` is reserved for VSCodeVim, `Shift+Esc` is the explicit "pop
up one layer" key, and only after that does the notebook list get bare Vim-like
keys. This preserves normal Vim muscle memory: you do not leave the cell when
you only meant to stop inserting text.

---

## 4. Cell-list-mode reference bindings

These belong in `keybindings.json`, not in VSCodeVim's `settings.json`, because
they call VSCode notebook/list commands.

| Key | Command ID | Meaning |
|---|---|---|
| `j` | `list.focusDown` | Select next cell |
| `k` | `list.focusUp` | Select previous cell |
| `g g` | `list.focusFirst` | Select first cell |
| `G` / `shift+g` | `list.focusLast` | Select last cell |
| `d d` | `notebook.cell.delete` | Delete selected cell(s) |
| `y` or `y y` | `notebook.cell.copy` | Copy selected cell(s) |
| `p` | `notebook.cell.paste` | Paste copied/cut cell(s) |
| `o` | `notebook.cell.insertCodeCellBelowAndFocusContainer` | Insert code cell below, stay in list mode |
| `O` / `shift+o` | `notebook.cell.insertCodeCellAboveAndFocusContainer` | Insert code cell above, stay in list mode |
| `x` | `notebook.cell.cut` | Cut selected cell(s) |
| `u` | `undo` | Undo notebook-level change |
| `i` | `notebook.cell.edit` | Enter edit mode for selected cell |
| `enter` | `notebook.cell.edit` | Optional second way to enter edit mode |

Use lowercase keys for the cell-list Vim layer. The older Mac config uses
uppercase `I`, `J`, `K`, `D D`, `Y`, `X`, `P`, and `U`; that means those keys are
shift-modified. That was likely a workaround, but it feels less like Vim. The
Windows config is the better reference: lowercase for ordinary Vim-like actions,
uppercase only where Vim normally uses it (`G`, `O`, possibly cell movement).

---

## 5. Cell execution bindings

Execution should work from both edit mode and cell-list mode.

| Key | Command ID | Meaning |
|---|---|---|
| `ctrl+enter` | `notebook.cell.executeAndFocusContainer` | Run current cell and stay on it / return to container |
| `shift+enter` | `notebook.cell.executeAndSelectBelow` | Run current cell and select the next cell |

The current Windows config scopes these to either edit-mode focus
(`editorTextFocus && inputFocus && notebookEditorFocused`) or cell-list focus
(`notebookCellListFocused`). It also removes default insert-cell bindings so
execution wins in the notebook container:

| Platform | Remove key | Removed command |
|---|---|---|
| Win/Linux | `ctrl+enter` | `-notebook.cell.insertCodeCellBelow` |
| Win/Linux | `shift+ctrl+enter` | `-notebook.cell.insertCodeCellAbove` |
| macOS | `cmd+enter` | `-notebook.cell.insertCodeCellBelow` |
| macOS | `shift+cmd+enter` | `-notebook.cell.insertCodeCellAbove` |

The principle: execution keys should not change meaning just because focus moved
from the cell editor to the notebook cell list.

---

## 6. Known gaps and improvements

### Moving cells up/down

The user wants to move cells, but the current configs do not bind this yet.
VSCode exposes `notebook.cell.moveUp` and `notebook.cell.moveDown`.

| Candidate | Pros | Cons |
|---|---|---|
| `shift+k` / `shift+j` | Vim-adjacent uppercase movement | Conflicts with shifted multi-select |
| `alt+k` / `alt+j` | Clear "move this item" chord | May conflict with OS/window manager |
| `space k` / `space j` | Fits leader-layer thinking | Depends on leader behavior in notebook list mode |

Recommendation: start with `alt+k` / `alt+j` if the OS does not steal them. If
you want the most Vim-like list layer, use uppercase `K` / `J` for movement and
put multi-selection somewhere else.

### Visual / multi-cell selection

The notebook-list equivalent of visual line mode is selecting a range of cells.
Use `notebook.cell.selectUp` and `notebook.cell.selectDown`, likely on
`shift+k` / `shift+j` if those are not used for movement. Once multiple cells are
selected, `dd`, `y`, `x`, paste, and move commands can operate on the range.

### Mac vs Windows consistency

Standardize on the Windows notebook section as the reference implementation:
`i`, not `I`; `j`/`k`, not `J`/`K`; `dd`, not `D D`; and `y`, `x`, `p`, `u`, not
`Y`, `X`, `P`, `U`. This gives one rule: if the notebook list has focus, pretend
the selected cell is the cursor and use normal Vim keys.

### Cross-platform note

This matches the broader `keybind-strategy.md` thesis: the most portable layer is
the modifier-light Vim/leader layer. Notebook cell-list mode is another version
of that idea. `j`, `k`, `gg`, `G`, `dd`, `y`, `p`, `o`, `O`, `x`, `u`, and `i`
can be identical on macOS, Linux, and Windows; only native app-chrome shortcuts
need to diverge.

---

## TL;DR / recommended next steps

1. Keep the two-layer model: **cell edit mode** is VSCodeVim; **cell-list mode**
   is `notebookEditorFocused && !inputFocus` with Vim-like whole-cell commands.
2. Preserve `Esc` for Vim. Use `Shift+Esc` to leave the cell editor.
3. Treat the Windows notebook section as the reference and standardize Mac to
   lowercase cell-list keys.
4. Add movement with `notebook.cell.moveUp` / `notebook.cell.moveDown`, likely on
   `alt+k` / `alt+j` unless those conflict.
5. Add multi-cell selection with `notebook.cell.selectUp` /
   `notebook.cell.selectDown`, then let `dd`, `y`, `x`, and movement act on the
   selected range.
6. Keep this notebook layer cross-platform and modifier-light, matching the main
   keybind strategy's OS-agnostic leader-layer philosophy.
