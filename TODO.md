# Important

* clear cache & registry, run BUILDKIT_PROGRESS=plain ./build-local.sh and fix all warnings

Inspect the Bluefin Base Image Bill of Materials:
Run an automated vulnerability/SBOM scan (e.g., trivy image or syft) inside your CI pipeline to catch unexpected upstream layer additions.

* hardening - flatpaks (check also what secureblue does)

~/.local/share/flatpak/overrides/com.github.tchx84.Flatseal
Ini, TOML

[Session Bus Policy]
org.gnome.Software=talk
org.freedesktop.impl.portal.PermissionStore=talk

~/.local/share/flatpak/overrides/io.github.flattool.Warehouse
Ini, TOML

[Session Bus Policy]
org.freedesktop.Flatpak=talk

!!! added filesystems=!host:reset;
check current flatpak settings

What This Script Does
It enforces a strict deny-by-default (zero-trust) security profile across all Flatpaks for the current user by writing extensive negative overrides to ~/.local/share/flatpak/overrides/global:

    Strips Broad Capabilities:

        Network & IPC: --unshare=network --unshare=ipc (cuts all internet and shared memory).

        Audio & X11: --nosocket=pulseaudio --nosocket=x11 --nosocket=fallback-x11 (kills audio and X11 access).

        Hardware: --nodevice=all --nodevice=input --nodevice=usb --nodevice=kvm.

        Filesystem: Denies access to home, host, host-etc, external media (/media, /run/media), and shell dotfiles (~/.bashrc, ~/.bash_profile).

    Blocks D-Bus Attack Surface:

        Rejects communication with dozens of known session and system D-Bus interfaces (GNOME Shell, KWallet, Secret Service, systemd, Mutter, NetworkManager).

    Applies a Minimal Baseline:

        Grants --socket=wayland and --device=dri (Wayland rendering + GPU acceleration only).

        Enables --persist=. to keep application state strictly inside ~/.var/app/<app_id>/.

    Bootstraps Flatseal:

        Grants com.github.tchx84.Flatseal access to the PermissionStore and GNOME Software so the user can manually grant permissions back via GUI.

Flatpak Hardening (secureblue approach):

    Implications: Applying global nosocket=fallback-x11, nosocket=pulseaudio, or restricted filesystem overrides significantly increases security but breaks out-of-the-box Flatpak usability (file pickers, screensharing, clipboard). Apply overrides selectively at /etc/flatpak/overrides/ (recommended/system-level, allows user override).

# After Install

* double/distorted cli line in vscode
* huge font in tips when hovering over nu functions (e.g. print)
* review vscode settings once again, compare to current
* screenshot with console in vscode, why this happens with zsh
* decide on no border theme
* vscode debug console font too big
* vscode output console font too big
* vscode debug console output line font too big

# Backlog

* VSCode
[Apc Customize UI+](https://marketplace.visualstudio.com/items?itemName=drcika.apc-extension)**
to change font size in editor
"apc.font.family": "'Inconsolata LGC Nerd Font Regular', sans-serif", "apc.listRow": { "fontSize": 14, // Forces text inside trees (Problems list/Explorer) to be larger "height": 22 // Manually keeps row spacing compact }

* disable boxes resize overlay
/* Hide the resolution overlay toast in GNOME Boxes */
.boxes-display-page adw-toast-overlay adw-toast {
    opacity: 0;
}
* qbittorrent to flatpak - untrusted P2P network traffic and complex torrent protocol parsers should be strictly constrained by
  Flatpak network and filesystem permissions (e.g., restricted strictly to ~/Downloads).
* not all skyblue changes are applied after rebase to an exisiting user (e.g. ptyxis theme). One way to fix is still to replace
  files in the user directory if checksum is the same as in /etc/skel or something like this
* check once again all /etc reference and if it is possible to get rid of them
* make mc cli prompt ">" green
* default hostname is always bluefin
* update all the stuff in /usr/lib/os-release (branding)
* vscode theme differs from local pc (borders, selection in left panel &c) but may be leave as is / wait for ayu update
* check extension that bluefin-dx preinstalls and settings overall in their github
* podman quadlets https://podman-desktop.io/blog/podman-quadlet
* investigate incus, incus vs docker
* check if there is any way to auto-renum lists in vscode md editor
* toolbox vs distrobox
* check if hardware acceleration in browsers is enabled
* check why nushell is not signed (gpgcheck=0 in repo)/signature check fails when enabled
* remove JetBrainsMono sinve nerd version is installed
* check once again which services are masked/disabled. Probably after removal of unnecessary packages
  they just do not exist anymore. It is better to not to touch these to not to break them if
  user decides to install them manually.
* invectigate enabling cockpit server, now client uses only bridge
* investigate GSConnect (recommandations in security)
* brighter red color for ptyxis sudo state
* check if vscode is using wayland by default
* check how to force all electron apps to use wayland
* apply branding in /etc/os-release
* read fedora release from /usr/lib/fedora-release, now 44 is hardcoded or read from cli out
* check for context-sensitive Ctrl+C, i.e. when there is a selection Ctrl+C should copy
* refactor everything what is possible from files
* remove queue buttons from qbittorrent
* fzf/fzf-tab skin colors
* preview alias fzf --preview 'bat --style=numbers --color=always {}'
* both fastfetch and neofetch installed, choose one, check if there are other
* gdm theme https://gdm-settings.github.io/
* distorted shell prompt on terminal resize, p10k readme has mitigations
* add everything to readme
* bad forged on date in fastfetch
* check access rights on all files
* first boot after rebase takes long time
* change ugly motd colors
* replace sky blue dracula palette in user folder from /etc/skel on user login
* predefined policies for adblock
* fix dns resolution in the virtual machine
* define themes as sky-blue-dynamic
* veracrypt version is hardcoded and fedora version is hardcoded for veracrypt package - change
* generate themed veracrypt icon
* TODO: firefox default settings common/system_files/bluefin/usr/share/ublue-os/firefox-config
* Enable user-theme@gnome-shell-extensions.gcampax.github.com
* Fix cosign stage warnings, why cosign doesn't fail?
* Verify checksum at least for veracrypt
* BitWarden extensions
* Disable rootful docker - for now only services are disabled
* extensions take time to install on first run of chrome and firefox, bundle during the build
* set default applications, seems that default choice is good already so can solve this later
* org.gnome.DejaDup for backups
* org.jupyter.JupyterLab
* com.logseq.Logseq
* com.zettlr.Zettlr

# Branding

* current motd implementation is very clunky - we overwrite ublue-os motd,
  investigate how to do this in a better way, leaving base motd untouched
  and redirecting to sblue files

# UI

* chrome buttons too big and do not have enough spacing in classic theme, same in vscode default theme
* firefox sidebars button not removed
* distorted colors in shell logout window
* less round corner in gnome shell windows
* mac colors for firefox buttons
* chrome on default theme has transparent header
* chrome on default theme has not skinned address popover
* square buttons in chrome in GTK theme
* button in pytxis on the right side has incorrect background
* ugly red on blue = sign in ini files in mc editor
* adopt bluefin default blurred shell config
