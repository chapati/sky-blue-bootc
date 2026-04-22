use common.nu *

print $"(ansi green)-- System setup flatpak hook --(ansi reset)"

let flatpak_config_path = "/usr/share/sblue/flatpak.json"

if not ($flatpak_config_path | path exists) {
  print "No configuration file found. Nothing to process."
  return
}

let to_remove = open $flatpak_config_path | get remove
let installed = (
  strict { ^flatpak list --columns=application } true 
  | lines 
  | str trim
)

print $installed

if ($to_remove | is-empty) {
  print "The removal list is empty."
  return
} else {
  $to_remove | each { |pkg|
    if ($pkg in $installed) {
      print $"(ansi cyan)Removing ($pkg)...(ansi reset)"
      
      # Ignore errors, we do not want the whole system setup script
      # to fail just because of flatpaks. Also they might be 
      # already uninstalled.
      try {
        ^flatpak uninstall --system --noninteractive -y $pkg
      } catch { |err|
        print $"Failed to uninstall ($pkg): ($err)"
      }
    } else {
      print $"(ansi yellow)($pkg) is not installed. Skipping.(ansi reset)"
    }
  }
}

print $"(ansi cyan)Pruning unused flatpak runtimes(ansi reset)"
try {
  ^flatpak uninstall --system --noninteractive --unused -y
}

# 1. Wait for the Flatpak lock (Essential since the user is now logged in!)
# The user might have opened GNOME Software, which will lock the DB.
# print "Waiting for Flatpak/OSTree locks..."
# loop {
#     let lock_active = (ps | where name =~ "flatpak|ostree" | length)
#     if $lock_active == 0 { break }
#     sleep 5sec # Longer sleep since we are in the background now
# }

# 2. Run with 'ionice' and 'nice' if possible
# This ensures the download doesn't make the user's YouTube video lag.
#print "Starting background Flatpak installation..."
#flatpak install --system -y flathub org.mozilla.firefox