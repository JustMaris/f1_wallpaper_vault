# 🏁 F1 Wallpapers

A personal collection of Formula 1 wallpapers, synced via GitHub for easy access across multiple devices.

## 📦 About

This repository contains various F1-themed wallpapers I've collected over time. There's some structure.

## 📥 Usage

You can clone or pull this repo to any device to keep your wallpaper collection in sync:

```bash
git clone https://github.com/yourusername/f1-wallpapers.git
```

Then just browse or use your OS's wallpaper tools to set them.

## 🖼️ Wallpaper Auto-Update Scripts (macOS, Linux, Windows)

This repository provides scripts to randomly set unique wallpapers per monitor on different operating systems.

### macOS

**Requirements:**

* [`desktoppr`](https://github.com/scriptingosx/desktoppr) installed via Homebrew:

```bash
brew install desktoppr
```

<details>
<summary>Use the provided <code>set-random-wallpapers-multi.sh</code> script</summary>

```zsh
#!/bin/zsh

WALLPAPER_ROOT="/path/to/your/f1-wallpapers"

num_screens=$(desktoppr | wc -l | tr -d ' ')

if (( num_screens == 0 )); then
  echo "No screens detected by desktoppr."
  exit 1
fi

wallpapers=()
while IFS= read -r -d '' file; do
  wallpapers+=("$file")
done < <(find "$WALLPAPER_ROOT" -type f -iname '*.jpg' -print0)

if (( ${#wallpapers[@]} < num_screens )); then
  echo "Not enough wallpapers (${#wallpapers[@]}) for $num_screens screens."
  exit 1
fi

function shuffle_array() {
  local i tmp size rand
  size=${#wallpapers[@]}
  for ((i = size; i > 1; i--)); do
    rand=$((RANDOM % i + 1))
    tmp=${wallpapers[i]}
    wallpapers[i]=${wallpapers[rand]}
    wallpapers[rand]=$tmp
  done
}

shuffle_array

selected=("${(@)wallpapers[1,$num_screens]}")

for ((i=0; i < num_screens; i++)); do
  wallpaper="${selected[i+1]}"
  echo "Setting wallpaper for screen $i: $wallpaper"
  desktoppr "$i" "$wallpaper"
done
```

</details>

Replace `/path/to/your/f1-wallpapers` with your actual path.

### Automating on macOS with `launchd`

<details>
<summary>Click to expand launchd configuration</summary>

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" 
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.maris.setwallpapers</string>

    <key>ProgramArguments</key>
    <array>
      <string>/path/to/set-random-wallpapers-multi.sh</string>
    </array>

    <key>EnvironmentVariables</key>
    <dict>
      <key>PATH</key>
      <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
    </dict>

    <key>StartInterval</key>
    <integer>300</integer>

    <key>RunAtLoad</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/tmp/setwallpapers.out</string>

    <key>StandardErrorPath</key>
    <string>/tmp/setwallpapers.err</string>
  </dict>
</plist>
```

</details>

Then load it:

```bash
launchctl unload ~/Library/LaunchAgents/com.maris.setwallpapers.plist 2>/dev/null
launchctl load ~/Library/LaunchAgents/com.maris.setwallpapers.plist
```

---

### Linux / Windows (Untested)

<details>
<summary>Click to view example Linux and Windows workflows</summary>

#### Linux

Install `feh` (Debian/Ubuntu):

```bash
sudo apt install feh
```

Example wallpaper script:

```bash
#!/bin/bash
WALLPAPER_ROOT="/path/to/f1-wallpapers"

mapfile -d '' wallpapers < <(find "$WALLPAPER_ROOT" -type f -iname '*.jpg' -print0)

num_screens=$(xrandr --listmonitors | tail -n +2 | wc -l)

if (( ${#wallpapers[@]} < num_screens )); then
  echo "Not enough wallpapers for $num_screens monitors."
  exit 1
fi

for ((i=0; i < num_screens; i++)); do
  feh --bg-scale "${wallpapers[i]}"
done
```

> Note: `feh` might set the last wallpaper on all screens depending on your DE.

---

#### Windows

Use third-party tools:

* [DisplayFusion](https://www.displayfusion.com/)
* [John's Background Switcher](https://johnsad.ventures/software/backgroundswitcher/)
* [Wallpaper Engine](https://store.steampowered.com/app/431960/Wallpaper_Engine/)

Sync wallpapers using Git for Windows. PowerShell support for multi-monitor setup is limited and typically requires Windows API access.

</details>

---

## 🔄 Syncing Across Devices

Keep your collection up to date by running:

```bash
git pull
```

Automate syncing with `cron`, `launchd`, Task Scheduler, or other tools.

---

## 📌 Notes

* Image copyrights belong to their original creators.
* Intended for personal use only.

---

## ✨ Suggestions

Contributions and suggestions are welcome! Feel free to open an issue or fork the repo.
