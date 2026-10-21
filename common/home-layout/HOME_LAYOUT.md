# Home folder layout

This is the layout I use for `~` on every Linux box I do research on: the
personal VPS and the shared lab servers. It is written so that Claude (or I)
can read it on a fresh machine and put things in the right place. To use it on
a machine, copy or symlink it to `~/HOME_LAYOUT.md` and point `~/CLAUDE.md` (or
`~/.claude/CLAUDE.md`) at it.

## Top level

```
~/
├── projects/          # active research projects, one folder per project
│   └── <project>/     # a repo, or a plain parent folder holding several repos
├── research-agenda/   # agenda thinking, reading notes, proposal drafts
├── phd/
│   ├── milestones/    # research exam, thesis proposal, defense
│   ├── coursework/    # one folder per course
│   └── admin/         # fellowships, applications, forms
├── refs/              # third-party repos cloned only to read
├── archive/           # finished or abandoned work, compressed when cold
└── misc/              # anything that fits nowhere else; keep it small
```

Not every machine needs every folder. Create one only when something goes in
it. A machine-specific folder (scratch, a mounted dataset) is fine as long as
it is listed in that machine's notes below.

## Rules

- **Nothing new at the top level.** A new clone goes in `projects/` if I work
  on it and `refs/` if I only read it. Ask before adding another top-level folder.
- **A project with several repos gets a plain parent folder,** for example
  `projects/ctx-editing/{ctx_editor,tau2-bench}`. Don't nest one repo inside
  another; it drags the inner repo into the outer one's linters, tests and searches.
- **Environments are uv.** Use a `.venv` per project (or per parent folder
  when its repos share one). No conda.
- **No absolute home paths in committed configs.** Resolve paths from the repo
  root, so that moving a project folder doesn't break it.
- **Archiving:** move the folder to `archive/`. When it's cold, compress it to
  `<name>.tar.zst` (`zstd --ultra -22 --long=27`) and add a short README or a
  log line saying what's inside. Before deleting the original, check that the
  file count in the archive matches.
- **Moving a folder orphans its Claude Code history.** Session history lives in
  `~/.claude/projects/<path with / and _ turned into ->`. Rename that folder to
  match the new path.

## Shared lab servers vs the personal machine

The VPS is private. Lab servers are shared, and on them `~` and `/data/<user>`
are usually world-readable (755). Admins can read everything regardless.

- **On lab servers, keep only what is fine for labmates and admins to see:**
  code, experiment outputs, datasets, course material.
- **Never on lab servers:** personal documents, PhD admin and correspondence
  (committee emails, fellowship applications), finances, secrets (`.env`, keys,
  tokens), or Claude session transcripts that came from the private machine.
- **Bulky data goes in `/data/<user>/`, not `~`.** Home partitions on lab
  servers tend to be nearly full. Check `df -h` before writing anything large.
- **Offloading from the private machine** goes into a mode-700 folder,
  `/data/<user>/vps-offload/`. Verify sha256 on both ends before deleting the
  local copy, and log each offload in `~/archive/OFFLOADED.md` on the private machine.

## Machine notes

Fill this in per machine: what it's for, where its scratch and data live, and
anything unusual about it.

| Machine | Role | Bulk storage | Notes |
| --- | --- | --- | --- |
| VPS | private research box | none (small disk) | personal; the source of offloads |
| lab servers | shared GPU and compute | `/data/<user>` | world-readable by default |
