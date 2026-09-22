# komorebi: Laptop mode
#
# Consolidates workspaces 1-6 onto the laptop so that all of 1-9 are
# accessible on the built-in screen once you undock.
#
# The permanent anchors "L" and "R" stay on the external monitors, so those
# monitors are never left with zero workspaces while still docked.
#
# Monitors are resolved by STABLE serial_number_id at runtime, because
# komorebi's internal monitor index order can reshuffle across
# reconnect/sleep -- so hardcoding indices is unreliable.
#
# Run this while STILL docked (all 3 monitors connected), then unplug.

$ErrorActionPreference = 'Stop'

$SERIAL_LEFT   = '16843009'   # Left 4K
$SERIAL_RIGHT  = '878334001'  # Right 4K
$SERIAL_LAPTOP = '0'          # Laptop built-in

# Build serial -> current monitor index map.
# NOTE: assign first, THEN enumerate. In Windows PowerShell 5.1 ConvertFrom-Json
# does not enumerate arrays, so @(cmd | ConvertFrom-Json) miscounts.
$monitors = komorebic monitor-info | ConvertFrom-Json
$bySerial = @{}
$idx = 0
foreach ($m in @($monitors)) {
    $bySerial[[string]$m.serial_number_id] = $idx
    $idx++
}

foreach ($s in @($SERIAL_LEFT, $SERIAL_RIGHT, $SERIAL_LAPTOP)) {
    if (-not $bySerial.ContainsKey($s)) {
        Write-Host "laptop-mode: monitor with serial '$s' not connected (need all 3). Dock first, then run before undocking."
        exit 1
    }
}

$idxLaptop = $bySerial[$SERIAL_LAPTOP]
$idxLeft   = $bySerial[$SERIAL_LEFT]
$idxRight  = $bySerial[$SERIAL_RIGHT]

function Move-WS([string]$ws, [int]$monitor) {
    komorebic focus-named-workspace $ws
    Start-Sleep -Milliseconds 120
    komorebic move-workspace-to-monitor $monitor
    Start-Sleep -Milliseconds 120
}

foreach ($ws in '1','2','3','4','5','6') { Move-WS $ws $idxLaptop }

# Re-assert the anchor workspace names on each monitor's index-0 slot. This keeps
# the anchors (L/R/B) correctly labelled and guards against a nameless default
# workspace ever sitting at index 0 (which the bar would render as "1", "2", ...).
# workspace-name RENAMES the existing index-0 workspace in place -- it never
# creates a new one -- so this is a no-op when the name is already correct.
komorebic workspace-name $idxLeft   0 L
komorebic workspace-name $idxRight  0 R
komorebic workspace-name $idxLaptop 0 B

komorebic focus-monitor $idxLaptop
komorebic retile
Write-Host "laptop-mode: done. You can now undock; workspaces 1-9 are all on the laptop."
