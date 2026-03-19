use common.nu *

# 
# This service has network.online target
# This service is oneshot. Do not perform any long-running tasks here. 
# Instead, spawn a background process to perform flatpak installation and other long-running tasks.
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue user setup --(ansi reset)"
  wait_service_end "ublue-user-setup" false "inactive" "dead"
}
