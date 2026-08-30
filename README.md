# Sky Blue Linux

This is a custum OCI Linux image based on the [ublueos/bluefin-nvidia-open:stable](https://ghcr.io/ublue-os/bluefin-nvidia-open:stable)
with several custom modifications aimed to provide secure, minimal and beautiful single-user developer workstation. All developer workflows
are supposed to be conducted using containers/toolbox/distrobox.

## Installation

* Install the latest [BlueFin](https://projectbluefin.io/)
* Switch to the Sky Blue image

```bash
sudo bootc switch ghcr.io/chapati/sky-blue-nvidia-open:latest --enforce-container-sigpolicy
systemctl reboot
```

## Features

* **Nushell:** Provided via upstream Gemfury RPM repository

**Native Web Browsers (System Packages):**
  * Google Chrome
  * Mozilla Firefox
  * Firefox Developer Edition
  * Vivaldi Stable

* **Hardened Browser Baseline:** System-level policies disable telemetry, tracking, and promotional clutter
  across all browsers, while provisioning essential content filtering and developer tools extensions.

* **BitWarden:** Desktop & Browser extensions.

* **UI Tweaks:**
  * custom wallpaper, icons theme, cursor theme
  * default system-wide dark theme
  * custom application themes
  * reduced gnome shell extensions set
  * custom dash-to-dock, blur-my-shell and other extensions config
  * InconsolataLGC and JetBrainsMono Nerd fonts

* **Added native packages:**
  * mc
  * veracrypt
  * strace
  * dconf-editor
  * sublime-merge
  * clapper
  * qbittorrent
  * g4music
  * foliate

* **Flatpaks replaced with native packages:**
  * com.github.tchx84.Flatseal
  * org.gnome.font-viewer
  * org.gnome.Firmware
  * org.gnome.Logs
  * org.gnome.Calculator
  * org.gnome.Calendar
  * org.gnome.Characters
  * org.gnome.Contacts
  * org.gnome.Loupe
  * org.gnome.NautilusPreviewer
  * org.gnome.TextEditor
  * org.gnome.FileRoller
  * org.gnome.Papers
  * org.gnome.baobab
  * org.gnome.Weather
  * org.gnome.clocks

* **Added Flatpaks:**
  * md.obsidian.Obsidian
  * org.telegram.desktop
  * com.mongodb.Compass
  * com.bitwarden.desktop
  * eu.betterbird.Betterbird
  * app.grayjay.Grayjay
  * org.cockpit_project.CockpitClient
  * de.haeckerfelix.Shortwave

* **Removed flatpaks & packages:**
  * org.gnome.Maps
  * org.gnome.Showtime
  * org.mozilla.Thunderbird
  * org.gnome.Connections
  * org.gnome.DejaDup
  * org.gnome.Snapshot
  * org.gnome.SimpleScan
  * tailscale
  * yubikey-manager

* **Rootless docker** - docker is pre-configured to run in a rootless mode by default

* **VSCode** - vscode with containers-related plugins, sane default and custom dark theme

## Security

* Built using a custom, declarative [Nushell](https://www.nushell.sh/)-based build system inspired by
  [BlueBuild](https://blue-build.org/), implemented natively to minimize external dependencies and reduce
  supply-chain attack surface.

* Browsers are installed as native system packages rather than Flatpaks to preserve their internal multi-process
  sandboxing (user namespaces, Landlock, and seccomp) and ensure full SELinux confinement without the isolation
  compromises caused by container nesting.

* Rootless docker. Docker binds containers to localhost if host is not specified.

## Credits

Many thanks to everybody who made my custom distro possible!

- [Universal Blue](https://universal-blue.org/)
- [Project Bluefin](https://projectbluefin.io/)
- [BlueBuild](https://blue-build.org/)
