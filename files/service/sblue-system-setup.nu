use common.nu *
use systemd.nu *

# 
# This service starts PRIOR the network.target
# This service is oneshot. Do not perform any long-running tasks here. 
#
def main [--base: path] {
  print $"(ansi green)-- Sky Blue system setup --(ansi reset)"
  wait_service_end "ublue-system-setup" true "inactive" "dead"

  let hooks_dir = "/usr/share/sblue/system-setup.hooks.d"
  if not ($hooks_dir | path exists) {
    die $"Hooks directory not found at: ($hooks_dir)"
  }

  for hook in (ls $hooks_dir | where type == file) {
    print $"(ansi cyan)Running system setup hook: ($hook.name)(ansi reset)"
    strict  {
      ^/usr/bin/nu --config /usr/libexec/sblue/config.nu $hook.name --base ($hook.name | path dirname)
    }
    # let $result = strict { 
    #   ^/usr/bin/nu --config /usr/libexec/sblue/config.nu $hook.name --base ($hook.name | path dirname)
    # }
    # if ($result.stdout | is-not-empty) { print $result.stdout }
    # if ($result.stderr | is-not-empty) { print -e $result.stderr }
  }
}
