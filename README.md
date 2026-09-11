# TMWatch

TMWatch is an alert-only Time Machine preflight watcher for macOS.

It runs `tmutil compare -s` against the latest Time Machine backup and estimates the next backup's write volume as:

    Added + Changed

Removed data is reported but is not counted toward the warning threshold.

## Install

```zsh
git clone https://github.com/mrjrask/tmwatch.git
cd tmwatch
chmod +x install.sh uninstall.sh tmwatch
./install.sh
```

Then make sure Terminal has Full Disk Access for the first manual test:

System Settings → Privacy & Security → Full Disk Access → Terminal

Run:

```zsh
~/.local/bin/tmwatch check
~/.local/bin/tmwatch details
~/.local/bin/tmwatch test-notification
```

The LaunchAgent checks every 30 minutes and skips checks while Time Machine is actively backing up.

## Commands

```text
tmwatch check
tmwatch status
tmwatch details
tmwatch log
tmwatch test-notification
tmwatch config
tmwatch help
```

## Configuration

The installed config lives at:

```text
~/Library/Application Support/TMWatch/config.env
```

Default threshold:

```text
THRESHOLD_GIB=25
```

## Notes

- v1 never stops, disables, or modifies Time Machine.
- `tmutil compare -s` can be I/O intensive and may take a while.
- Full Disk Access may be necessary for complete comparison results.
- macOS notifications are generated through AppleScript.
