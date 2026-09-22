# Cross-Platform Keybind Strategy (macOS / Linux / Windows)

Context: primary machine is a MacBook, hobby work on Linux, interning on a forced
Windows box at MSR. VSCode everywhere, plus Obsidian and terminal emulators
(kitty / Windows Terminal, usually tmux inside). Already uses VSCode Vim and has
prior Neovim/Vim experience.

---

## 1. The core mental model: separate the two layers

Almost all cross-OS pain comes from conflating two different layers:

| Layer | Modifier usage | Cross-platform consistency |
|---|---|---|
| **Vim motions + leader keys** (`hjkl`, `<space>ff`, `gd`, `ciw`, `[d`/`]d`) | Modifier-*free* | **Identical on every OS** |
| **App/editor chords** (`Cmd/Ctrl+Shift+P`, `Cmd/Ctrl+P`, `Cmd+B`) | Heavy modifier use | **Diverge per OS** (Cmd on Mac, Ctrl on Win/Linux) |

Collisions live almost entirely in the second layer. **Strategy: push as much as
possible into the leader-key layer, which is OS-agnostic by design.**

---

## 2. VK_OEM_4 / scan codes — quick reference

- `VK_OEM_*` (e.g. `oem_4 = [`, `oem_6 = ]`, `oem_2 = /`, `oem_1 = ;`) is
  **Windows-only Win32 vocabulary**. Linux uses evdev keycodes + xkb keysyms;
  macOS uses `kVK_*`.
- **Virtual keys = logical/layout-dependent** (what character the key produces).
- **Scan codes = physical key position**, layout-independent and the *more*
  portable layer.
- **Rule of thumb:** character/command meaning → virtual key; physical position
  → scan code.
- In VSCode `keybindings.json`, prefer the scan-code form `[BracketLeft]` /
  `[BracketRight]` / `[Slash]` over `oem_4` / `oem_6` / `oem_2`. The scan-code
  form behaves consistently across US/non-US layouts **and** across macOS, where
  `oem_*` is unreliable.

---

## 3. Recommendation: commit to the LazyVim-style leader layer

Go with LazyVim → VSCode-Vim keybinds — not because they're objectively superior,
but because:

1. The leader key (`<space>`) carries **no modifier**, so `<space>ff`, `<space>sg`,
   `<space>e`, etc. are byte-for-byte identical on macOS, Linux, and Windows. One
   muscle memory, everywhere.
2. Low cognitive cost given prior Neovim/Vim background.
3. It sidesteps the exact Cmd-vs-Ctrl problem — leader mappings don't care which
   key is the "command-ish" modifier.

This is the single biggest lever for a 3-OS person.

### Keep ONE config, identical on all platforms
- Enable **VSCode Settings Sync** (sign in with GitHub) so `settings.json`,
  `keybindings.json`, and extensions follow you to all three machines.
- Do **not** vary keybinds per OS — that recreates the problem you're killing.
- Put nearly everything behind `<leader>`; let VSCode's own defaults differ for
  the few native chords.

### Still learn a small core of native chords (as concepts, not literal keys)
These work outside the editor buffer where Vim isn't focused:
- Command Palette (`Cmd/Ctrl+Shift+P`)
- Quick Open (`Cmd/Ctrl+P`)
- Toggle terminal / sidebar / panel
- Editor-group + tab navigation

Encode them mentally as **"meta + key"** and let the OS resolve Cmd vs Ctrl. That
reframing is what makes the platform differences stop hurting.

### Engine choice
- **VSCodeVim** — lighter, easy leader mappings via
  `vim.normalModeKeyBindingsNonRecursive`. Covers ~90% of LazyVim-style flow.
  **Recommended starting point**, especially on a locked-down Windows box.
- **vscode-neovim** — real embedded Neovim, closer to "true LazyVim," more setup
  and occasional rough edges. Migrate later only if you miss real Neovim plugins.

---

## 4. Review of the gist template (`template.txt`)

It's a VSCodeVim + LazyVim `keybindings.json` (modifier-chord layer only; leader
bindings are meant to live in `settings.json`). Overall reasonable, but:

### Must fix before it will load
- **Invalid JSON — missing commas between objects.** Confirmed it fails to parse
  at the suggestion-widget block (~line 205) and the entire `ctrl+1..5` section
  has no commas between the objects. VSCode will reject the whole file until
  these are added.

### Cross-platform improvements (important for you)
- **Replace `oem_4` / `oem_6` / `oem_2` with `[BracketLeft]` / `[BracketRight]` /
  `[Slash]`.** The gist's own notes admit `oem_*` is unreliable on macOS and
  non-US layouts. Scan codes give you one form that works on all three OSes.
- **`ctrl+up` / `ctrl+down` (window resize) collides with macOS Mission Control /
  Spaces.** Either remap those to something else or expect them to be swallowed
  on the Mac. Worth changing since you want identical behavior everywhere.

### Minor / cleanup
- **Duplicate `ctrl+oem_2` bindings** (unconditional toggle + `!terminalFocus`
  focus) partially overlap; intent is slightly muddy. Pick one behavior.
- The `ctrl+h/j/k/l` window-nav bindings are correctly guarded with
  `!terminalFocus` (so `ctrl+h`=backspace, `ctrl+l`=clear still work in the
  terminal) — good. Keep those guards.
- Suggestion-widget block is marked `#TODO EXPERIMENTAL`; validate it overrides
  window-nav correctly (it should, since `suggestWidgetVisible` is more specific).

### Verdict
Usable foundation and well-commented, but **not** what I was going to hand you —
my earlier offer was to generate a fresh config. Best path: fix the commas, swap
`oem_*` → scan codes, resolve the macOS Ctrl+Arrow conflict, then adopt it and
sync.

---

## 5. Obsidian

You already have the Mac↔Windows switch internalized, so no overhaul needed.
Optional consistency wins:
- Enable **Obsidian's Vim mode** (Editor settings) so your in-editor motions
  match VSCode — the modifier-free Vim layer ports for free, same as VSCode.
- Sync the vault config via Obsidian Sync or a git-backed vault so hotkeys stay
  identical across machines.
- Obsidian's command hotkeys are the equivalent of VSCode's "native chord" layer;
  treat them the same way — memorize the few you use as "meta + key" concepts.

---

## 6. Terminals + tmux

This layer is *already* mostly OS-agnostic, for the same reason the leader layer
is:
- **tmux prefix (`Ctrl-b` by default) + key is modifier-light and identical on
  every OS.** Keep one `.tmux.conf` everywhere. Many remap prefix to `Ctrl-a` or
  `Ctrl-space`; whatever you pick, it ports unchanged.
- The divergence is at the **emulator chrome** layer (kitty vs Windows Terminal
  use different modifiers for new-tab/split/copy). Accept that those differ per
  app — they're outside tmux and rarely muscle-memory-critical.
- Watch the **3-way layering**: emulator shortcut → tmux prefix → shell/readline.
  Keep them on distinct modifiers so they don't stomp each other (e.g. emulator
  on Cmd/Ctrl+Shift, tmux on prefix, shell on bare Ctrl).
- Mirror your Vim navigation into tmux pane nav (`prefix h/j/k/l`) for one
  consistent hjkl story across VSCode splits, tmux panes, and the file explorer.

---

## TL;DR

1. **Adopt the LazyVim-style leader layer** — its modifier-free `<space>`
   bindings are the clean fix for Cmd-vs-Ctrl collisions.
2. **One identical config everywhere**, propagated via Settings Sync. Don't vary
   per OS.
3. **Learn ~8 native chords as "meta + key" concepts**, letting Cmd/Ctrl resolve
   themselves.
4. **Start with VSCodeVim**, not vscode-neovim.
5. **Fix the gist before use:** add missing commas, switch `oem_*` → scan codes
   (`[BracketLeft]` etc.), resolve the macOS Ctrl+Arrow conflict.
6. **Obsidian:** turn on Vim mode + sync the vault; you're otherwise fine.
7. **tmux/terminal:** keep one prefix-based config; differences are only at the
   emulator-chrome layer, which doesn't need to match.
