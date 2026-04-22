use common.nu *
use systemd.nu *
use hooks.nu *

# 
# This service has network.online target
# This service is simple. You can safely perform long-running tasks
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue system online setup --(ansi reset)"
  wait_service_end "sblue-system-setup" true "active" "exited"

  let hooks_dir = "/usr/share/sblue/system-online.hooks.d"
  run_hooks $hooks_dir
}
