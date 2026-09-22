#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Build the themed ActivityWatch web UI into a custom_static directory.
#
# aw-server-rust can serve the web UI from an arbitrary directory instead of
# the one baked into the app bundle. This copies the bundle's built web UI,
# drops the Rosé Pine sheets in, and links them from index.html — so the theme
# survives app updates without forking aw-webui.
#
# Re-run after every ActivityWatch upgrade (the bundle's JS/CSS filenames are
# content-hashed, so the copy must be refreshed).
#
# Usage:  ./install-theme.sh [--dest DIR]
# ---------------------------------------------------------------------------
set -euo pipefail

APP="/Applications/ActivityWatch.app"
SRC="$APP/Contents/Resources/aw_server/static"
DEST="${HOME}/Documents/mattbook/tooling/aw-webui-themed"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="${HOME}/Library/Application Support/activitywatch/aw-server-rust/config.toml"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dest) DEST="$2"; shift 2 ;;
    *) echo "unknown argument: $1" >&2; exit 2 ;;
  esac
done

[[ -d "$SRC" ]] || { echo "error: web UI not found at $SRC (is ActivityWatch installed?)" >&2; exit 1; }
for f in rose-pine.css rose-pine-moon.css; do
  [[ -f "$HERE/$f" ]] || { echo "error: missing $HERE/$f" >&2; exit 1; }
done

echo "==> source : $SRC"
echo "==> dest   : $DEST"

rm -rf "$DEST"
mkdir -p "$DEST"
cp -R "$SRC"/. "$DEST"/

# The light sheet is loaded unconditionally; the Moon sheet replaces the
# stock dark.css, which aw-webui injects itself when the theme resolves dark.
# aw-server-rust only serves known top-level paths (index.html, dark.css,
# logo.*, manifest.json) plus the css/ js/ fonts/ trees — an arbitrary new
# file at the root 404s. So the light sheet goes into css/.
cp "$HERE/rose-pine.css"      "$DEST/css/rose-pine.css"
cp "$HERE/rose-pine-moon.css" "$DEST/dark.css"

# Link the light sheet last in <head> so it outranks the bundled Bootstrap CSS.
python3 - "$DEST/index.html" <<'PY'
import sys, re
p = sys.argv[1]
html = open(p, encoding="utf-8").read()
if "css/rose-pine.css" in html:
    print("    index.html already linked")
else:
    link = '<link href="/css/rose-pine.css" rel="stylesheet">'
    if "</head>" not in html:
        sys.exit("error: no </head> in index.html")
    html = html.replace("</head>", link + "</head>", 1)
    open(p, "w", encoding="utf-8").write(html)
    print("    index.html patched")
PY

# The service worker caches the old CSS aggressively; drop it from the copy so
# a reload actually shows the theme.
rm -f "$DEST/service-worker.js" "$DEST/service-worker.js.map"

echo "==> built."
echo
# The web UI is compiled into aw-server-rust; `--webpath` overrides it. That is
# a CLI flag, and aw-qt.toml has no way to pass module arguments — so the server
# runs from its own LaunchAgent, and aw-qt (which probes for an already-running
# server and adopts it) is configured to start only the watchers.
AGENT="${HOME}/Library/LaunchAgents/com.activitywatch.aw-server-rust.plist"
if grep -q -- "--webpath" "$AGENT" 2>/dev/null && grep -q "$DEST" "$AGENT" 2>/dev/null; then
  echo "LaunchAgent already points at this directory. Restart to pick up changes:"
  echo "    launchctl kickstart -k gui/\$(id -u)/com.activitywatch.aw-server-rust"
else
  cat <<EOF
Now point the server at it. In $AGENT the ProgramArguments must be:

    /Applications/ActivityWatch.app/Contents/Resources/aw-server-rust
    --webpath
    $DEST

and ~/Library/Application Support/activitywatch/aw-qt/aw-qt.toml must NOT list
aw-server-rust in autostart_modules (the agent owns the server).

Then:
    launchctl kickstart -k gui/\$(id -u)/com.activitywatch.aw-server-rust
EOF
fi
