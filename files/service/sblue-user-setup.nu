use common.nu *
use systemd.nu *
use hooks.nu *

#
# This service has network.online target
# This service is simple. You can safely perform long-running tasks here.
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue user setup --(ansi reset)"
  wait_service_end "ublue-user-setup" false "inactive" "dead"

  let hooks_dir = "/usr/share/sblue/user-setup.hooks.d"
  run_hooks $hooks_dir
}
