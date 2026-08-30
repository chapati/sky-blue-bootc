use common.nu *

print $"(ansi green)-- User setup docker hook --(ansi reset)"

# Resolve dynamic runtime paths based on user ID / XDG_RUNTIME_DIR
let uid = (id -u | str trim)
let xdg_runtime = ($env.XDG_RUNTIME_DIR? | default $"/run/user/($uid)")
let docker_sock = $"($xdg_runtime)/docker.sock"

# Run installer idempotently (skips reinstall if service is already running)
strict {
  let is_active = (^systemctl --user is-active docker.service | complete).exit_code == 0
  if not $is_active {
    ^dockerd-rootless-setuptool.sh install
  } else {
    print $"(ansi cyan)Docker rootless service is already running.(ansi reset)"
  }
}

# Ensure Docker CLI context points to rootless daemon
strict {
  ^docker context use rootless
}

# Set for current active session
$env.DOCKER_HOST = $"unix://($docker_sock)"

# Persist DOCKER_HOST permanently for Bash and Zsh
let rc_files = [ "~/.bashrc", "~/.zshrc" ] | each { |p| $p | path expand }
let export_line = "\n# Rootless Docker Socket\nexport DOCKER_HOST=\"unix://${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/docker.sock\"\n"

for rc in $rc_files {
  let content = if ($rc | path exists) {
    open $rc | into string
  } else {
    ""
  }

  if not ($content | str contains "DOCKER_HOST") {
    $export_line | save --append $rc
    print $"(ansi green)Persisted DOCKER_HOST to ($rc)(ansi reset)"
  }
}
