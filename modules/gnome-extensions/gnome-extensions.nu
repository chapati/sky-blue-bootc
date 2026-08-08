use common.nu *

def remove_exts [remove: list<string>] {
  if ($remove | is-empty) {
    die "No extensions specified for removal"
  }

  # Get list of currently installed extension UUIDs
  let installed = (
    strict { ^gnome-extensions list } true
    | lines
    | str trim
  )

  $remove | each { |uuid|
    if $uuid in $installed {
      print $"(ansi cyan)Removing ($uuid)...(ansi reset)"

      try {
        ^gnome-extensions disable $uuid err> (null-device)
      } catch {
        # ignore disable errors, might be
        # already disabled
      }

      strict {
        ^gnome-extensions uninstall $uuid
      }
    } else {
      print $"Extension ($uuid) is not installed, skipping."
    }
  } | ignore
}

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)
    validate_params $params ["install", "remove"]

    # let install = ($params | get -o install)
    # if $install != null {
    #     install_exts $install
    # }

    let remove = ($params | get -o remove)
    if $remove != null {
        remove_exts $remove
    }
}