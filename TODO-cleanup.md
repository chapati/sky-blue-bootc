* Size of all packages on disk
rpm -qa --queryformat '%{SIZE}\n' | awk '{s+=$1} END {printf "%.2f GB\n", s/1024/1024/1024}'

* Biggest packages
rpm -qa --queryformat '%{SIZE}\t%{NAME}\n' | sort -rn | head -n 25 | awk '{printf "%.1f MB\t%s\n", $1/1024/1024, $2}'

* Check present


subversion* perl-Git-SVN	SVN — obsolete, use git or container
python3-bcc, python3-osbuild*, python3-librepo, python3-rpm	Dev/build Python libs — use toolbox
osbuild*, libosbuild	Image build tool — shouldn't be on target image
pcp*, sysstat	Performance monitoring — use container
tuned, tuned-ppd	Power tuning — conflicts with GNOME power-profiles
thermald, intel-lpmd	Intel thermal — let firmware/PPD handle
mcelog	Legacy RAS — rasdaemon replaces it
powertop	Power analysis — use occasionally in toolbox
iotop-c, tiptop, nicstat, bpftop	Monitoring — use toolbox
strace	Debugging — use toolbox
lsof, tree, time, bc, lrzsz, mpage, symlinks, dosfstools, exfatprogs, ntfs-3g*, hfsplus-tools, f2fs-tools, nilfs-utils, bcache-tools, xfsprogs, gdisk, lsscsi, compsize	Filesystem/disk tools — use toolbox
7zip, 7zip-standalone, zip, unzip, bsdunzip, squashfs-tools, lzop, zstd (binary), xz (binary)	Archive tools — use Flatpak or toolbox
whois, mtr, traceroute, netcat, tcpdump, bind-utils, ipset, iptables*, nftables-services, dnsmasq, wireguard-tools, openvpn, vpnc, openconnect, NetworkManager-* (vpn plugins)	Network tools/VPNs — use toolbox or Flatpak VPN clients
usbip, usbutils, pciutils, ethtool, iw, wireless-regdb, b43-*, fxload	Hardware tools — use toolbox
ddcutil, i2c-tools, lm_sensors, evtest, input-remapper, libratbag-ratbagd, solaar-udev, oversteer-udev, openrgb-udev-rules	Hardware tweaking — use toolbox, keep udev rules only if devices present
spice-* (server, webdavd, vdagent)	SPICE server — client only needed
hyperv-*, open-vm-tools*, virtualbox-guest-additions, qemu-guest-agent	Hypervisor guests — keep only what's needed for your hypervisor
fwupd-plugin-modem-manager, fwupd-plugin-uefi-capsule-data	FWUPD plugins — remove if no modem/UEFI capsule need
cockpit-* (all 6 packages)	Web admin — use container or remove
realmd, adcli, oddjob*, sssd* (except sssd-client maybe)	AD/domain join — use toolbox if needed
clevis*, luksmeta, libluksmeta, jose	TPM2/LUKS auto-unlock — remove if not using
borgbackup, restic, rclone, duplicity, cryfs, fuse-encfs, davfs2	Backup/encryption tools — use Flatpak/toolbox
veracrypt	Encryption — use Flatpak
sublime-merge, code (VS Code), mc, dconf-editor	Apps — use Flatpak
vivaldi-stable, google-chrome-stable, firefox (keep one)	Browsers — use Flatpak for all
qbittorrent	Use Flatpak
nushell	Already have fish/zsh — use homebrew or Flatpak
tmux, zsh, zsh-*, fzf, bat, eza, zoxide, glow, gum, just, htop, fastfetch, pv	CLI tools — use homebrew in ~/.local or toolbox
distrobox	Already have toolbox — pick one
nerd-fonts, jetbrains-mono*, cascadia-code-fonts, opendyslexic-fonts	Fonts — install to ~/.local/share/fonts
papirus-icon-theme*	Theme — install to ~/.icons or use Flatpak
breeze-cursor-theme	Cursor — install to ~/.icons
gnome-shell-extension-* (blur-my-shell, gsconnect, etc.)	Extensions — use Extension Manager Flatpak
gnome-rounded-blur	Theme — user install
uupd	Ublue updater — conflicts with bootc/rpm-ostree
ublue-os-* (akmods-addons, nvidia-addons)	Ublue-specific — review if needed
supergfxctl	ASUS dGPU switching — remove if not ASUS laptop
zfs, kmod-zfs, libzfs*, libzpool*, python3-pyzfs	ZFS — use container or remove if not using ZFS pools
docker-ce, docker-model-plugin	Duplicate Docker

Current RPM	Flatpak Alternative
firefox	org.mozilla.firefox
google-chrome-stable / vivaldi-stable	com.google.Chrome / com.vivaldi.Vivaldi
code (VS Code)	com.visualstudio.code
sublime-merge	com.sublimemerge.App
qbittorrent	org.qbittorrent.qBittorrent
mc	io.github.midnight_commander.MidnightCommander or toolbox
veracrypt	No official Flatpak — use AppImage or toolbox
dconf-editor	ca.desrt.dconf-editor
gnome-tweaks	Partially replaced by Settings; use if needed
foliate	com.github.johnfactotum.Foliate
clapper	com.github.rafostar.Clapper
deja-dup	org.gnome.DejaDup
flatseal	com.github.tchx84.Flatseal
snapshot	org.gnome.Snapshot
loupe	org.gnome.Loupe
papers / evince	org.gnome.Papers

Key security/usability wins

    Remove docker-ce stack — rootful daemon, conflicts with Podman, larger attack surface
    Remove samba server bits — samba-libs pulled by gvfs-smb is enough
    Strip QEMU to essentials — qemu-kvm-core + virt-manager needs only
    Remove dev toolchain — gcc, kernel-devel, etc. belong in toolbox
    Remove cockpit — web-exposed admin on workstation is risk
    Consolidate browsers to Flatpak — sandboxed, auto-updated, smaller base image

