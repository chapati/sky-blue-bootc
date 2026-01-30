# Sky Blue Linux

This is a custum oci-based Linux image based on the Project Bluefin with several custom modifications. At the moment bluefin-nvidia-open:stable is used as a base.

## Installation

* Install the latest [BlueFin](https://projectbluefin.io/)
* Switch to the Sky Blue image

```bash
sudo bootc switch ghcr.io/chapati/sky-blue-bootc:latest --enforce-container-sigpolicy
systemctl reboot
```

## Features

Installed fedora packages:

- bpftop
- cascadia-code-fonts
- htop
- iotop
- libvirt & related 
- mc
- nicstat
- numactl
- podman & related
- qemu & related
- sysprof
- incus
- incus-agent
- lxc
- tiptop
- trace-cmd
- udica
- util-linux-script
- virt-manager
- virt-viewer
- ydotool

3rd-party packages:

- 


## Credits

Many thanks to everybody who made my custom distro possible!

- [Universal Blue](https://universal-blue.org/)
- [Project Bluefin](https://projectbluefin.io/)
- [BlueBuild](https://blue-build.org/)
- [Rich Renomeron](https://github.com/rrenomeron/bootc-images)
