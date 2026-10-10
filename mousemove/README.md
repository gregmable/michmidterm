mousemove — small utility to nudge the macOS mouse cursor every 60 seconds

This repository contains a simple bash script that uses AppleScript (osascript) to nudge the mouse cursor by one pixel and then move it back. It's intended to prevent screen savers or "idle"-based actions on macOS.

Files
- move_mouse.sh — the script. Make it executable and run it.

Usage
1. Open Terminal.
2. Make the script executable:

   chmod +x "/Users/mablg/Library/Developer/Xcode/UntitledProjects/mousemove/move_mouse.sh"

3. Run it:

   "/Users/mablg/Library/Developer/Xcode/UntitledProjects/mousemove/move_mouse.sh"

Notes and permissions
- The script uses AppleScript to move the cursor. The first time you run it you may be prompted to grant Accessibility permissions to Terminal (or whichever shell app you run it from). Open System Settings → Privacy & Security → Accessibility and enable the app.
- To stop the script: press Ctrl+C in the Terminal where it's running.
- If you prefer a launchd job to run at login, I can help create a plist for that.

Safety
- The script moves the cursor for a very short time and then returns it to its original position.
- Test manually by running once to ensure the behavior is acceptable on your system.
