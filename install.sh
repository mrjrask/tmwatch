#!/bin/zsh
set -e

APP_DIR="${HOME}/Library/Application Support/TMWatch"
BIN_DIR="${HOME}/.local/bin"
AGENT_DIR="${HOME}/Library/LaunchAgents"
PLIST="${AGENT_DIR}/com.jason.tmwatch.plist"
SOURCE_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$APP_DIR/bin" "$APP_DIR/logs" "$APP_DIR/state" "$BIN_DIR" "$AGENT_DIR"

cp "$SOURCE_DIR/tmwatch" "$APP_DIR/bin/tmwatch"
chmod 755 "$APP_DIR/bin/tmwatch"
ln -sf "$APP_DIR/bin/tmwatch" "$BIN_DIR/tmwatch"

if [[ ! -f "$APP_DIR/config.env" ]]; then
  cp "$SOURCE_DIR/config.env" "$APP_DIR/config.env"
  chmod 600 "$APP_DIR/config.env"
fi

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.jason.tmwatch</string>
  <key>ProgramArguments</key>
  <array>
    <string>${APP_DIR}/bin/tmwatch</string>
    <string>check</string>
  </array>
  <key>StartInterval</key>
  <integer>1800</integer>
  <key>RunAtLoad</key>
  <true/>
  <key>ProcessType</key>
  <string>Background</string>
  <key>StandardOutPath</key>
  <string>${APP_DIR}/logs/launchd.out.log</string>
  <key>StandardErrorPath</key>
  <string>${APP_DIR}/logs/launchd.err.log</string>
</dict>
</plist>
EOF

/usr/bin/plutil -lint "$PLIST"

USER_ID="$(id -u)"
/bin/launchctl bootout "gui/${USER_ID}" "$PLIST" >/dev/null 2>&1 || true
/bin/launchctl bootstrap "gui/${USER_ID}" "$PLIST"
/bin/launchctl enable "gui/${USER_ID}/com.jason.tmwatch"

print
print "TMWatch installed."
print
print "Command:"
print "  ${BIN_DIR}/tmwatch"
print
print "IMPORTANT: grant Full Disk Access to the process that runs TMWatch."
print "For the first manual test, grant Full Disk Access to Terminal:"
print "  System Settings → Privacy & Security → Full Disk Access → Terminal"
print
print "Then run:"
print "  ${BIN_DIR}/tmwatch check"
print "  ${BIN_DIR}/tmwatch test-notification"
print
print "If ~/.local/bin is not already in your PATH, add this to ~/.zshrc:"
print '  export PATH="$HOME/.local/bin:$PATH"'
