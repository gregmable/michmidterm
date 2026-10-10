#!/bin/bash
# move_mouse.sh — move the macOS mouse cursor by 1 pixel then back every 60 seconds
# Usage: chmod +x move_mouse.sh && ./move_mouse.sh
# Press Ctrl+C to stop.

# Loop forever, moving the mouse slightly every 60 seconds
while true; do
  /usr/bin/osascript <<'APPLESCRIPT'
  -- AppleScriptObjC: get current mouse location and nudge the cursor by 1 pixel
  use framework "AppKit"
  use scripting additions

  on run
    set p to current application's NSEvent's mouseLocation()
    set xPos to p's x as integer
    set yPos to p's y as integer

    -- CGWarpMouseCursorPosition expects coordinates with origin at bottom-left in global display coordinates
    set newX to xPos + 1
    set newY to yPos

    current application's CGWarpMouseCursorPosition({newX, newY})
    delay 0.02
    current application's CGWarpMouseCursorPosition({xPos, yPos})
  end run
APPLESCRIPT

  sleep 60
done
