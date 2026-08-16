# Important

* change hostname to skyblue

# Backlog
* predefined policies for adblock
* fix dns resolution in the virtual machine
* investigate moving files from /etc to /user/share + tmpfiles
* define theme name globally and reference everywhere where Graphite-blue-Dark-ayu is used
* ctx-browsers is stale at the moment, invalidate in build.yaml / track version
* gnome shell theme not applied
* veracrypt version is hardcoded and fedora version is hardcoded for veracrypt package - change
* generate themed veracrypt icon
* TODO: firefox default settings common/system_files/bluefin/usr/share/ublue-os/firefox-config
* custom theme for ptyxis that looks like the system theme? (may be not necessary, caputchin looks fine)
* Enable user-theme@gnome-shell-extensions.gcampax.github.com
* Fix cosign stage warnings, why cosign doesn't fail?
* Verify checksum at least for veracrypt
* BitWarden extensions
* Disable rootful docker - for now only services are disabled

# Branding

* current motd implementation is very clunky - we overwrite ublue-os motd,
  investigate how to do this in a better way, leaving base motd untouched
  and redirecting to sblue files

# UI

* distorted colors in shell logout window
* less round corner in gnome shell windows
* mac colors for firefox buttons
