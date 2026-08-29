# Security

* **Hardened Default Firewall Zone (`public`):**
  * The default zone is set to a hardened `public` profile with `target="DROP"`, silently discarding all unsolicited inbound packets
    (closing unprivileged ports `1025–65535`, SSH, and mDNS).
  * Stateful outbound connections and essential IPv6 autoconfiguration (SLAAC / DHCPv6 client) are preserved.
  * Inbound ports for required local services (e.g., Samba, GSConnect/KDE Connect) must be enabled explicitly by the user
    or assigned to trusted zones.

* **Disabled LLMNR (Link-Local Multicast Name Resolution):**
  * `LLMNR=no` is enforced in `systemd-resolved` (closing TCP/UDP port `5355`).
  * Mitigates local subnet spoofing, credential capture, and poisoning attacks on untrusted networks.
  * Single-label peer-to-peer hostname fallback on unmanaged Windows networks is disabled; standard DNS resolution is unaffected.

* **Masked `avahi-daemon` & Client-Only mDNS:**
  * `avahi-daemon` service and socket are masked (closing UDP port `5353`), eliminating broadcast host announcements and reducing
    background attack surface.
  * `MulticastDNS=resolve` is enabled in `systemd-resolved`, allowing the system to resolve remote `*.local` hostnames in a stealth
    client-only mode without advertising itself.
  * Automatic network printer/scanner zero-conf discovery (Bonjour/DNS-SD) is disabled; network printers must be added manually
    via IP address or hostname in CUPS. Local USB printing remains functional.

* **Disabled & Masked services:**
  * ModemManager.service, org.gnome.SettingsDaemon.Wwan.service - Cellular LTE/5G modem management.
  * iscsi-starter.service, iscsi-onboot.service - iSCSI SAN storage initiator
  * multipathd.service - Device Mapper Multi-Pathing for SANs.
  * gssproxy.service, gssuserproxy.service - Kerberos authentication.
  * sssd.service, sssd-kcm.service - System Security Services Daemon. Enable if workstation needs to join an Active Directory,
    LDAP, or FreeIPA enterprise domain.
  * realmd.service - D-Bus daemon for joining Active Directory / FreeIPA realms.
  * malcontent-timerd.service - GNOME Parental Controls & Screen Time limits
  * vboxservice.service - VirtualBox guest agent
  * vmtoolsd.service, vgauthd.service - VMware guest agents
  * virtxend.service - Xen driver for libvirt
  * virtvboxd.service - VirtualBox driver for libvirt
  * virtlxcd.service - LXC driver for libvirt
  * zfs-* - OpenZFS support
  * mcelog.service - legacy (>10y) intel servers support
  * gvfs-gphoto2-volume-monitor - cameras support
  * app-vboxclient@autostart, app-vmware\x2duser@autostart - VirtualBox & VMware clipboard/display helpers.

## Features

* **Optimized Virtualization Stack:** Purged multi-arch QEMU targets, static user emulators, and non-x86 firmware in favor of a minimal
  native x86_64 KVM stack with GNOME Boxes and Virt-Manager.

* **Removed from the base system:**
  * Samba client tools - the full Samba client stack (including Winbind for Active Directory auth) is unnecessary on a single-user workstation.
    `gvfs-smb` and `cifs-utils` handle all common SMB use cases — browsing shares in Nautilus and mounting via `mount -t cifs`.

Installed as native packages:

- mc
- nushell from gemfury nushell repo
- google chrome stable from google repository
- firefox developer edition from mozilla website
- vivaldi stable from official vivaldi repo
- sublime merge
- veracrypt
- qbittorrent
- clapper
- foliate
- g4music
- dconf-editor
- gnome-boxes

Flatpaks added:

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
- Shortwave

Flatpaks replaced with the native packages. SkyBlue prefers native fedora-reviewed packages over flatpaks due to many security implications
of flatpaks.

- firefox
- flatseal
- thunderbird (replaced with betterbird)
- pinta
- gnome-calculator
- gnome-calendar
- gnome-characters
- file-roller
- gnome-firmware
- gnome-logs
- gnome-weather
- loupe
- sushi
- papers-previewer
- snapshot
- gnome-text-editor
- baobab
- deja-dup

Removed from base bluefin:

- TailScale VPN client
- Gnome Connections
- Gnome Maps
- Showtime
- SimpleScan
- Gnome Clocks

Due to security implications SkyBlue tries to reduce base environment attack surface as much as possible. For example we
tend to remove software written in python and python packages. The following packagees were removed:

- yubikey manager (python)

UI & cosmetic stuff:

- Breeze Light cursor theme
- Papirus icon theme with the nordic folders flavor
- GTK & Shell theme based on modified Graphite-gtk-theme
- custom dash to dock config
- custom blur my shell config
- custom logo menu config
- color picker extension
- user-theme extension
- removed 'apps menu', 'places status indicator', 'launch new instance' and 'windows list' gnome shell extensions
- custom Dracula-based Ptyxis theme which works well with mc

