# komorebi: Office mode
#
# Fans the movable workspaces back to their home monitors:
#   Left 4K  : 2 5 6
#   Right 4K : 1 3 4
#   Laptop   : 7 8 9
#
# The permanent anchor workspaces "L" (left) and "R" (right) are never moved,
# so those monitors always keep at least one workspace.
#
# Monitors are resolved by STABLE serial_number_id at runtime, because
# komorebi's internal monitor index order can reshuffle across
# reconnect/sleep -- so hardcoding indices is unreliable.
#
# Run this AFTER docking, with all 3 monitors connected.

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
        Write-Host "office-mode: monitor with serial '$s' not connected (need all 3). Dock first."
        exit 1
    }
}

$idxLeft   = $bySerial[$SERIAL_LEFT]
$idxRight  = $bySerial[$SERIAL_RIGHT]
$idxLaptop = $bySerial[$SERIAL_LAPTOP]

function Move-WS([string]$ws, [int]$monitor) {
    komorebic focus-named-workspace $ws
    Start-Sleep -Milliseconds 120
    komorebic move-workspace-to-monitor $monitor
    Start-Sleep -Milliseconds 120
}

foreach ($ws in '2','5','6') { Move-WS $ws $idxLeft }
foreach ($ws in '1','3','4') { Move-WS $ws $idxRight }
foreach ($ws in '7','8','9') { Move-WS $ws $idxLaptop }

komorebic focus-monitor $idxLeft
komorebic retile
Write-Host "office-mode: done."
