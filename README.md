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

Installed fedora packages:

- mc
- firefox flatpak replaced with the native package due to security implications

3rd-party packages:

- nushell from gemfury nushell repo
- google chrome stable installed from google repository

UI & cosmetic stuff:

- breeze cursor theme installed, breeze-white as default
- custom dash to dock config

## Credits

Many thanks to everybody who made my custom distro possible!

- [Universal Blue](https://universal-blue.org/)
- [Project Bluefin](https://projectbluefin.io/)
- [BlueBuild](https://blue-build.org/)
- [Rich Renomeron](https://github.com/rrenomeron/bootc-images)
