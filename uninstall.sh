#!/bin/zsh
set -e

APP_DIR="${HOME}/Library/Application Support/TMWatch"
PLIST="${HOME}/Library/LaunchAgents/com.jason.tmwatch.plist"
LINK="${HOME}/.local/bin/tmwatch"
USER_ID="$(id -u)"

if [[ -f "$PLIST" ]]; then
  /bin/launchctl bootout "gui/${USER_ID}" "$PLIST" >/dev/null 2>&1 || true
  rm -f "$PLIST"
fi

rm -f "$LINK"
rm -rf "$APP_DIR"

print "TMWatch has been removed."
