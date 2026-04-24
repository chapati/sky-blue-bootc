# Sky Blue Linux

This is a custum oci-based Linux image based on the Project Bluefin DX with several custom modifications. At the moment bluefin-dx-nvidia-open:stable is used as a base.

## Installation

* Install the latest [BlueFin](https://projectbluefin.io/)
* Switch to the Sky Blue image

```bash
sudo bootc switch ghcr.io/chapati/sky-blue-nvidia-open:latest --enforce-container-sigpolicy
systemctl reboot
```

## Features

Installed as native packages:

- mc
- nushell from gemfury nushell repo
- google chrome stable from google repository
- firefox flatpak replaced with the native package due to security implications
- firefox developer edition from mozilla website
- sublime merge
- veracrypt
- qbittorrent
- clapper
- valutwarden
- foliate
- g4music

Flatpaks:

- Obsidian
- Telegram Desktop
- MongoDb Compass
- BitWarden Desktop
- BetterBird
- Grayjay
- Tauon
- Slack
- Zoom
- Cockpit Client

Removed from base bluefin:

- tailscale VPN client

BlueFin flatpaks replaced with the native packages. SkyBlue prefers
native fedora-reviewed packages over flatpaks.

- firefox
- flatseal
- thunderbird replaced with betterbird
- pinta
- gnome-calculator 

UI & cosmetic stuff:

- breeze cursor theme installed, breeze-white set as default
- custom dash to dock config

## Credits

Many thanks to everybody who made my custom distro possible!

- [Universal Blue](https://universal-blue.org/)
- [Project Bluefin](https://projectbluefin.io/)
- [BlueBuild](https://blue-build.org/)
- [Rich Renomeron](https://github.com/rrenomeron/bootc-images)
