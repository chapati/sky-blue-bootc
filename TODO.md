# Important

* assess chrome theme - input too dark - need to make custom theme, manifest allows to change that color
* chrome buttons too big and do not have enough spacing in classic theme
* ugly prompt in mc in tumbleweed
* theme in vscode cli is too bright also not synced with ptyxis
* bad prompt line start in mc (artifact from shell prompt)
* bad active menu color in mc theme
* too light inactive menu color in mc theme (try #262626)
* selection is not working properly in codeblocks in obsidian, most likely because of font size for ```
* list which ports are opened and remove / close unnecessary
* hardening - default firewall rules to deny
* rootless docker

# Backlog
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

# Branding

* current motd implementation is very clunky - we overwrite ublue-os motd,
  investigate how to do this in a better way, leaving base motd untouched
  and redirecting to sblue files

# UI

* firefox sidebars button not removed
* distorted colors in shell logout window
* less round corner in gnome shell windows
* mac colors for firefox buttons
* chrome on default theme has transparent header
* chrome on default theme has not skinned address popover
* square buttons in chrome in GTK theme
* button in pytxis on the right side has incorrect background
* ugly red on blue = sign in ini files in mc editor
