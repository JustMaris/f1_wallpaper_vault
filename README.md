# 🏁 F1 Wallpapers [ARCHIVED]

> [!CAUTION]
> **This repository is officially archived and no longer maintained.**

### 🛑 Why this project is deprecated
Maintaining a collection of ~10,000 high-resolution images (approx. 13GB) via Git has proven technically unfeasible for the following reasons:

* **Git History Bloat:** Git is designed for text versioning. Tracking binary blobs (images) means every addition or change is stored in the `.git` folder history forever. This leads to a massive local repository size (13GB+) that makes `git pull` and `git status` extremely slow.
* **macOS Cache Inflation:** The native macOS wallpaper engine creates a cached version of every image set as a background. Rotating through thousands of unique image paths causes `wallpaper.db` and system support folders to balloon, eating up GBs of system storage.
* **Better Alternatives:** Tools designed for media syncing (like Syncthing) or web-based wallpaper rendering (like Plash) handle large-scale collections without the metadata overhead of Git.

---

## 🏎️ Original Project Info
A personal collection of Formula 1 wallpapers, previously synced via GitHub for access across devices.

**Main source of photos:** [Album by NonStopF1](https://photos.app.goo.gl/gGKXYSNM9xmJTMrF8)

## 📦 Legacy Scripts (Provided As-Is)
The scripts below are preserved for historical reference and educational purposes. Use at your own risk.

<details>
<summary><b>macOS Auto-Update Script (Legacy)</b></summary>

**Requirements:** [`desktoppr`](https://github.com/scriptingosx/desktoppr) installed via Homebrew.

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

<details>
<summary><b>Automating on macOS with launchd</b></summary>

Save as a `.plist` file in `~/Library/LaunchAgents/com.f1.setwallpapers.plist`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "[http://www.apple.com/DTDs/PropertyList-1.0.dtd](http://www.apple.com/DTDs/PropertyList-1.0.dtd)">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.f1.setwallpapers</string>
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
  </dict>
</plist>
```
</details>

---

## 🛠️ Recommended Modern Setup
To achieve a similar multi-device setup without the technical debt:

1.  **Syncing:** Use **[Syncthing](https://syncthing.net/)** (Open Source). It is a peer-to-peer sync engine that doesn't keep a 13GB version history of your images.
2.  **Display Engine:** Use **[Plash](https://github.com/sindresorhus/Plash)** (Open Source). It renders wallpapers in a browser layer, which prevents the macOS wallpaper cache from growing.
3.  **Live Content:** For video loops or interactive F1 dashboards, check out **[Aerial](https://github.com/JohnCoates/Aerial)** or **[Styx](https://github.com/Dvorak-S/Styx)**.

---

## 📌 Notes
* Image copyrights belong to their original creators.
* These scripts were developed for personal use and are no longer being updated for new OS versions.
