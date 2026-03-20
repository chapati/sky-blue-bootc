use common.nu *
use systemd.nu *

# 
# This service starts PRIOR the network.target
# This service is oneshot. Do not perform any long-running tasks here. 
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue system setup --(ansi reset)"
  wait_service_end "ublue-system-setup" true "inactive" "dead"
}


# # Wait for ublue-user-setup to finish
# print "Waiting for ublue-user-setup to complete..."

# loop {
#     let status = (systemctl is-active ublue-user-setup.service | str trim)
#     let substate = (systemctl show ublue-user-setup.service --property=SubState | str replace "SubState=" "" | str trim)
    
#     # If it's finished (dead) or failed, we break the loop and continue
#     if $status == "inactive" or $status == "failed" { 
#         print $"Ublue setup finished with substate: ($substate)"
#         break 
#     }
    
#     sleep 1sec
# }

# # Now continue with your Sky Blue logic...