use common.nu *

# 
# This service has network.online target
# This service is simple. You can safely perform long-running tasks
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue system online setup --(ansi reset)"
  wait_service_end "sblue-system-setup" true "active" "exited"
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