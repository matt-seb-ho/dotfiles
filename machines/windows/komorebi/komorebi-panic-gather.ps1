# komorebi: Panic Gather  (EXPERIMENTAL backup recovery)
#
# Use this ONLY if you undocked WITHOUT running laptop-mode first, and some of
# your windows from workspaces 1-6 are now stranded/invisible (komorebi cached
# the external monitors and left those windows COM-cloaked).
#
# What it does:
#   1. Asks komorebi which window handles it currently manages (komorebic state).
#   2. Enumerates all top-level windows and finds ones that are CLOAKED but NOT
#      managed by komorebi -- those are the stranded windows.
#   3. Force-activates each, which un-cloaks it; komorebi then re-tiles it onto
#      the laptop's currently focused workspace.
#   4. Retiles.
#
# The recovered windows pile onto the current workspace; redistribute them with
# alt + shift + N afterwards.
#
# SAFETY: only runs when exactly ONE monitor (the laptop) is connected, so it
# can't disrupt a docked multi-monitor setup. The "reliable" recovery is still
# to briefly re-dock, run laptop-mode, then undock -- see KEYBINDINGS.md.
#
# NOTE: This is experimental. Un-cloaking a COM-cloaked window from a script is
# not guaranteed by Windows; if a window won't come back, click its taskbar icon
# (that always works). A log is written to %TEMP%\komorebi-panic-gather.log.

$ErrorActionPreference = 'Continue'
$log = Join-Path $Env:TEMP 'komorebi-panic-gather.log'
function Log($m) { $line = "{0}  {1}" -f (Get-Date -Format 'HH:mm:ss'), $m; Add-Content -Path $log -Value $line; Write-Host $line }
"" | Set-Content -Path $log
Log "panic-gather: starting"

# --- resolve komorebic ---
$komorebic = 'komorebic'
if (-not (Get-Command komorebic -ErrorAction SilentlyContinue)) {
    $full = 'C:\Program Files\komorebi\bin\komorebic.exe'
    if (Test-Path $full) { $komorebic = $full }
    else { Log "ERROR: komorebic not found (run from elevated PowerShell)"; exit 1 }
}

# --- safety guard: laptop-only (assign first, THEN count: PS 5.1 ConvertFrom-Json quirk) ---
$monitors = & $komorebic monitor-info | ConvertFrom-Json
$monitorCount = @($monitors).Count
if ($monitorCount -ne 1) {
    Log "panic-gather: aborting -- meant for laptop-only use, but found $monitorCount monitors. Dock-free undock recovery only."
    exit 1
}

# --- collect HWNDs komorebi already manages (exclude these from the gather) ---
$stateRaw = & $komorebic state | Out-String
$managed = New-Object System.Collections.Generic.HashSet[int64]
foreach ($m in [regex]::Matches($stateRaw, '"hwnd"\s*:\s*(\d+)')) {
    $h = [int64]$m.Groups[1].Value
    if ($h -gt 0) { [void]$managed.Add($h) }
}
Log "panic-gather: komorebi currently manages $($managed.Count) window(s)"

# --- Win32 interop ---
if (-not ([System.Management.Automation.PSTypeName]'KPG.Native').Type) {
Add-Type @"
using System;
using System.Runtime.InteropServices;
namespace KPG {
  public static class Native {
    [DllImport("user32.dll")] public static extern IntPtr FindWindowEx(IntPtr parent, IntPtr childAfter, string cls, string win);
    [DllImport("user32.dll")] public static extern int GetWindowTextLength(IntPtr h);
    [DllImport("user32.dll")] public static extern bool IsWindowVisible(IntPtr h);
    [DllImport("user32.dll")] public static extern IntPtr GetWindow(IntPtr h, uint cmd);
    [DllImport("user32.dll", EntryPoint="GetWindowLongPtrW")] public static extern IntPtr GetWindowLongPtr(IntPtr h, int idx);
    [DllImport("user32.dll")] public static extern void SwitchToThisWindow(IntPtr h, bool altTab);
    [DllImport("user32.dll")] public static extern bool ShowWindow(IntPtr h, int cmd);
    [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr h);
    [DllImport("dwmapi.dll")] public static extern int DwmGetWindowAttribute(IntPtr h, int attr, out int val, int size);
  }
}
"@
}

$GWL_EXSTYLE     = -20
$WS_EX_TOOLWINDOW = 0x00000080
$WS_EX_APPWINDOW  = 0x00040000
$GW_OWNER        = 4
$DWMWA_CLOAKED   = 14
$SW_RESTORE      = 9

function Is-AltTabApp([IntPtr]$h) {
    if (-not [KPG.Native]::IsWindowVisible($h)) { return $false }
    if ([KPG.Native]::GetWindowTextLength($h) -le 0) { return $false }
    $ex = [int64][KPG.Native]::GetWindowLongPtr($h, $GWL_EXSTYLE)
    if (($ex -band $WS_EX_TOOLWINDOW) -ne 0) { return $false }
    $owner = [KPG.Native]::GetWindow($h, $GW_OWNER)
    if ($owner -eq [IntPtr]::Zero) { return $true }
    return (($ex -band $WS_EX_APPWINDOW) -ne 0)
}

function Is-Cloaked([IntPtr]$h) {
    $val = 0
    $hr = [KPG.Native]::DwmGetWindowAttribute($h, $DWMWA_CLOAKED, [ref]$val, 4)
    return ($hr -eq 0 -and $val -ne 0)
}

# --- enumerate top-level windows, collect stranded (cloaked + unmanaged + app) ---
$candidates = New-Object System.Collections.Generic.List[IntPtr]
$h = [KPG.Native]::FindWindowEx([IntPtr]::Zero, [IntPtr]::Zero, $null, $null)
while ($h -ne [IntPtr]::Zero) {
    $id = [int64]$h
    if (-not $managed.Contains($id)) {
        if ((Is-AltTabApp $h) -and (Is-Cloaked $h)) {
            $candidates.Add($h)
        }
    }
    $h = [KPG.Native]::FindWindowEx([IntPtr]::Zero, $h, $null, $null)
}

Log "panic-gather: found $($candidates.Count) stranded (cloaked, unmanaged) window(s)"

if ($candidates.Count -eq 0) {
    Log "panic-gather: nothing to recover. If a window is still missing, click its taskbar icon."
    exit 0
}

# --- force-activate each so Windows un-cloaks it and komorebi re-tiles it ---
foreach ($w in $candidates) {
    [KPG.Native]::ShowWindow($w, $SW_RESTORE) | Out-Null
    [KPG.Native]::SwitchToThisWindow($w, $true)
    [KPG.Native]::SetForegroundWindow($w) | Out-Null
    Start-Sleep -Milliseconds 300
}

Start-Sleep -Milliseconds 200
& $komorebic retile | Out-Null
Log "panic-gather: done. Recovered $($candidates.Count) window(s) onto the laptop. Redistribute with alt+shift+N."
