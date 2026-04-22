use common.nu *
use systemd.nu *
use hooks.nu *

# 
# This service starts PRIOR the network.target
# This service is oneshot. Do not perform any long-running tasks here. 
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue system setup --(ansi reset)"
  wait_service_end "ublue-system-setup" true "inactive" "dead"

  # let hooks_dir = "/usr/share/sblue/system-setup.hooks.d"
  # run_hooks $hooks_dir
}
