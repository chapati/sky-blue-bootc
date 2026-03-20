use common.nu *
use systemd.nu *

# 
# This service has network.online target
# This service is simple. You can safely perform long-running tasks here. 
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue user setup --(ansi reset)"
  wait_service_end "ublue-user-setup" false "inactive" "dead"
}
