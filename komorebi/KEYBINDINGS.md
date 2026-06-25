# komorebi Keyboard Shortcuts

An i3/sway-style cheat sheet for this komorebi setup (3 monitors, 9 global workspaces).

> **Modifier:** `alt`
> The Windows key is avoided because it collides with built-in OS shortcuts.
> To switch, replace every `alt` with `win` in `~/.config/whkdrc`.

---

## Mental model (read this first)

- **Workspaces are unique and global**, named `1`–`9`. They're addressed **by name**, so
  `alt + N` always jumps to workspace `N` no matter which monitor it currently lives on —
  exactly like i3.
- **Anchor workspaces** `L`, `R`, and `B` are *permanent* parking slots that always stay on
  the left 4K, right 4K, and laptop (built-in) respectively. They exist so a monitor is never
  left with zero workspaces when you shuffle `1`–`9` around (e.g. moving `7 8 9` off the
  laptop onto a bigger screen). They're not on a number key; ignore them or use them as
  scratch space.
- **Office default home monitors** (the layout the mode scripts restore):

  | Monitor index | Physical screen | Home workspaces      |
  |:-------------:|-----------------|:--------------------:|
  | `0`           | Left 4K         | `L` (anchor) `2 5 6` |
  | `1`           | Right 4K        | `R` (anchor) `1 3 4` |
  | `2`           | Laptop          | `B` (anchor) `7 8 9` |

  Any workspace can still be relocated at runtime; the scripts just snap things back.

---

## Workspaces

| Shortcut              | Action                                                        |
|-----------------------|---------------------------------------------------------------|
| `alt + 1` … `alt + 9` | Focus workspace 1–9 (global; follows the workspace's monitor) |
| `alt + shift + 1..9`  | Send focused window to workspace 1–9 (no follow, i3-style)    |

## Move a whole workspace to another monitor (i3 "move workspace to output")

The entire workspace (with its windows) relocates; `alt + N` still finds it afterward.

| Shortcut                    | Action                                  |
|-----------------------------|-----------------------------------------|
| `alt + ctrl + shift + h`    | Move current workspace → Left 4K (0)    |
| `alt + ctrl + shift + l`    | Move current workspace → Right 4K (1)   |
| `alt + ctrl + shift + j`    | Move current workspace → Laptop (2)     |
| `alt + ctrl + ,`            | Move current workspace → previous monitor |
| `alt + ctrl + .`            | Move current workspace → next monitor   |

## Monitors (move focus between screens)

| Shortcut          | Action                       |
|-------------------|------------------------------|
| `alt + ctrl + h`  | Focus Left 4K (monitor 0)    |
| `alt + ctrl + l`  | Focus Right 4K (monitor 1)   |
| `alt + ctrl + j`  | Focus Laptop (monitor 2)     |
| `alt + ,`         | Cycle to previous monitor    |
| `alt + .`         | Cycle to next monitor        |

## Focus windows

| Shortcut             | Action                  |
|----------------------|-------------------------|
| `alt + h / j / k / l`| Focus left/down/up/right|
| `alt + shift + [`    | Cycle focus previous    |
| `alt + shift + ]`    | Cycle focus next        |

## Move windows within the layout

| Shortcut                | Action                 |
|-------------------------|------------------------|
| `alt + shift + h/j/k/l` | Move left/down/up/right|
| `alt + shift + enter`   | Promote to main        |

## Stacking (i3-style tabbed containers)

Stack windows together into one tile; the focused window's name shows in the komorebi bar.

| Shortcut             | Action                         |
|----------------------|--------------------------------|
| `alt + a / s / d / f`| Stack with neighbour left/down/up/right |
| `alt + u`            | Unstack focused window         |
| `alt + [`            | Cycle to previous in stack     |
| `alt + ]`            | Cycle to next in stack         |

## Layout

| Shortcut       | Action                  |
|----------------|-------------------------|
| `alt + space`  | Cycle to next layout    |
| `alt + x`      | Flip layout horizontally|
| `alt + y`      | Flip layout vertically  |

## Resize

| Shortcut              | Action                     |
|-----------------------|----------------------------|
| `alt + =`             | Grow width                 |
| `alt + -`             | Shrink width               |
| `alt + shift + =`     | Grow height                |
| `alt + shift + -`     | Shrink height              |

## Window management

| Shortcut          | Action                        |
|-------------------|-------------------------------|
| `alt + q`         | Close focused window          |
| `alt + m`         | Minimize focused window       |
| `alt + t`         | Toggle float                  |
| `alt + shift + f` | Toggle monocle (fullscreen)   |
| `alt + shift + r` | Retile / re-apply layout      |
| `alt + p`         | Pause / resume komorebi       |

## Reload

| Shortcut          | Action                                |
|-------------------|---------------------------------------|
| `alt + shift + o` | Reload komorebi configuration         |
| `alt + shift + c` | Restart whkd (reload these keybinds)  |

## Mode switching (office ⇄ laptop)

| Shortcut          | Action                                                          |
|-------------------|----------------------------------------------------------------|
| `alt + shift + d` | **Office mode** — fan `2 5 6`→left, `1 3 4`→right, `7 8 9`→laptop |
| `alt + shift + u` | **Laptop mode** — pull `1`–`6` onto the laptop, ready to undock   |
| `alt + shift + g` | **Panic gather** — recover stranded windows if you forgot laptop mode |

Both mode scripts require all 3 monitors connected (run while docked). They live at
`C:\Users\<you>\.config\komorebi-office-mode.ps1` and `komorebi-laptop-mode.ps1`.

> These shuffle the **already-running** komorebi between layouts. For a full
> **restart** while undocked, see *Starting / restarting komorebi* below — a plain
> docked restart while undocked seeds workspaces 1-6 onto external monitors that
> aren't there.

## Starting / restarting komorebi (docked vs laptop)

komorebi is started, not bound to a key (whkd isn't running yet). From an
**elevated** PowerShell:

| Command                                         | Use when                                   |
|-------------------------------------------------|--------------------------------------------|
| `komorebic start --whkd --bar --clean-state`    | **Docked** (default, 3 monitors)           |
| `.\komorebi-start.ps1`                          | Docked, via the wrapper (same as above)    |
| `.\komorebi-start.ps1 -Laptop`                  | **Undocked** restart (built-in screen only)|

`komorebi-start.ps1` defaults to docked; `-Laptop` loads the single-monitor
`komorebi.laptop.json` (anchor `B` + workspaces `1`-`9`, one bar) so a cold start
while undocked never tries to seed `1`-`6` on the absent external monitors. Stop is
the same in both modes: `komorebic stop --whkd --bar`.

> **Why two laptop tools?** `alt + shift + u` (laptop-mode.ps1) re-shuffles a
> *running* komorebi and must run **while docked** (it needs all 3 monitors).
> `komorebi-start.ps1 -Laptop` is for a **cold start/restart while already
> undocked**, when there's nothing to shuffle.

### If you undock WITHOUT running laptop mode first
When you undock, komorebi caches the external monitors and leaves their inactive-workspace
windows **COM-cloaked** (hidden). Because of how the cloak works, a plain komorebi restart
does **not** bring them back. Recovery options, best first:

1. **Re-dock briefly → `alt + shift + u` (laptop mode) → undock.** Reconnecting makes komorebi
   restore and un-cloak the cached windows. This is the bulletproof fix when a monitor is
   reachable.
2. **Click the app's taskbar icon** (or Alt-Tab to it). Activating a window un-cloaks it and
   komorebi tiles it onto the laptop. Works with no external monitor, one window at a time.
3. **`alt + shift + g` (panic gather, experimental).** Finds all cloaked-but-unmanaged windows
   and force-activates them so komorebi re-tiles them onto the laptop's current workspace;
   redistribute with `alt + shift + N`. Only runs when the laptop is the sole monitor. Logs to
   `%TEMP%\komorebi-panic-gather.log`. If a window won't come back, fall back to option 2.

---

## Multi-monitor & roaming

**Docked (3 monitors):** workspaces 1–3 live on the left 4K, 4–6 on the right 4K, 7–9 on
the laptop. `alt + N` switches on whichever monitor owns `N`; use the *move workspace to
monitor* keys to fan things out differently.

**Laptop only (meetings / home):**

- Before undocking, press **`alt + shift + u`** (laptop mode) while still connected to all
  3 monitors. This pulls workspaces `1`–`6` onto the laptop so all of `1`–`9` are reachable
  once you unplug. Press **`alt + shift + d`** (office mode) after redocking to fan them back
  out.
- If you undock *without* running laptop mode, only `7 8 9` are navigable; apps left on
  `1`–`6` are cached/minimized — bring any of them over with **`alt + tab`** or the taskbar,
  and everything is restored on redock.

**Plug / unplug safety** — set these once in
**Settings → System → Display → Multiple displays**:

- Disable *"Remember window locations based on monitor connection"*
- Enable *"Minimize windows when a monitor is disconnected"*

If komorebi ever loses track of a monitor after a hotplug, run `komorebic monitor-info`;
replug the screen or `komorebic stop && komorebic start --whkd --bar`.

---

## Files & locations

| File                              | Windows path                          |
|-----------------------------------|---------------------------------------|
| `komorebi.json`                   | `C:\Users\<you>\`                     |
| `komorebi.laptop.json`            | `C:\Users\<you>\`                     |
| `komorebi.bar.monitor1/2/3.json`  | `C:\Users\<you>\`                     |
| `komorebi.bar.laptop.json`        | `C:\Users\<you>\`                     |
| `whkdrc` (no extension)           | `C:\Users\<you>\.config\`             |
| `komorebi-office-mode.ps1`        | `C:\Users\<you>\.config\`             |
| `komorebi-laptop-mode.ps1`        | `C:\Users\<you>\.config\`             |
| `komorebi-start.ps1`              | `C:\Users\<you>\.config\`             |
| `komorebi-panic-gather.ps1`       | `C:\Users\<you>\.config\`             |

**Start everything (docked):** `komorebic start --whkd --bar --clean-state`
**Start undocked (laptop only):** `.\komorebi-start.ps1 -Laptop`
**Check resolved whkdrc path:** `komorebic whkdrc`

> **Note:** `komorebic` only works from an **elevated (Administrator) PowerShell**,
> because it talks to the elevated `komorebi.exe`. whkd (and anything it launches,
> including the mode scripts) must therefore also be started elevated.

---

## Troubleshooting

### Stale / leftover workspaces after editing the config
komorebi dumps its live state to `%TEMP%\komorebi.state.json` and **auto-restores it on
every start**, so a plain stop/start keeps old workspaces around. Force a clean rebuild from
`komorebi.json`:

```powershell
komorebic stop
komorebic start --clean-state --whkd --bar
```

After one clean start you can go back to the normal `komorebic start --whkd --bar`.

### Removing a single workspace at runtime
`komorebic close-workspace` removes the **focused** workspace, but only if it is **empty**,
**unnamed**, and **not the only workspace** on its monitor. Our workspaces (`1`–`9`, `L`,
`R`, `B`) are all *named* on purpose, so this won't touch them — use `--clean-state` to clear
stray unnamed ones instead.

### Office / laptop mode shortcuts do nothing
- Both scripts **require all 3 monitors connected** — run them while docked. Undocked, they
  print a "need 3 monitors" message and exit.
- They must run **elevated** (same reason as komorebic above). If whkd was not started from
  an elevated shell, the `komorebic` calls inside the scripts will fail silently.
- Test a script directly from an **Administrator PowerShell**:
  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "$Env:USERPROFILE\.config\komorebi-office-mode.ps1"
  ```
- If `komorebic` isn't recognized even in admin PowerShell, the scripts can be pointed at the
  full path `C:\Program Files\komorebi\bin\komorebic.exe` instead.

### Workspaces land on the wrong monitor
komorebi's **internal monitor index order is not stable** — it can reshuffle across
reconnect/sleep (e.g. index 1 and 2 swapping between the laptop and right 4K). The mode
scripts therefore resolve each monitor by its **stable `serial_number_id`** at runtime rather
than a hardcoded index. If you swap hardware, update the serials at the top of both scripts
(get them from `komorebic monitor-info`):

| Variable        | Monitor   | serial_number_id |
|-----------------|-----------|------------------|
| `$SERIAL_LEFT`  | Left 4K   | `16843009`       |
| `$SERIAL_RIGHT` | Right 4K  | `878334001`      |
| `$SERIAL_LAPTOP`| Laptop    | `0`              |
