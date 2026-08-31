# Important

* vscode theme extension + other extensions
* default hostname is always bluefin
* assess chrome theme - input too dark - need to make custom theme to allow changes to theme in the future, manifest allows to change input color
* theme in vscode cli is too bright also not synced with ptyxis
* bad prompt line start in mc (artifact from shell prompt)
* selection is not working properly in codeblocks in obsidian, most likely because of font size for ```
* hardening - flatpaks (check also what secureblue dues)
* using `sed -i` without the `--follow-symlinks` option breaks symlinks,
* home (and other) key does not work in ptyxis
* clear cache & registry, run BUILDKIT_PROGRESS=plain ./build-local.sh and fix all warnings
* check extension that bluefin-dx preinstalls and settings overall in their github
* assess using systemd-homed

# Backlog

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
