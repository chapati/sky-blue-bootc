use common.nu *

export def run_hooks [hooks_dir: path] {
  if ($hooks_dir | is-empty) {
    die $"hooks_dir param is empty"
  }

  if not ($hooks_dir | path exists) {
    die $"Hooks directory not found at: ($hooks_dir)"
  }

  for hook in (ls $hooks_dir | where type == file) {
    print $"(ansi cyan)Running hook: ($hook.name)(ansi reset)"
    strict  {
      ^/usr/bin/nu --config /usr/libexec/sblue/config.nu $hook.name
    }
  }
}
