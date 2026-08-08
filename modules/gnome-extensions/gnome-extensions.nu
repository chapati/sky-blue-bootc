use common.nu *

let exts_dir = "/usr/share/gnome-shell/extensions"

def remove_exts [remove: list<string>] {
  if ($remove | is-empty) {
    die "No extensions specified for removal"
  }

  $remove | each { |uuid|
    let ext_path = [$exts_dir $uuid] | path join
    if ($ext_path | path exists) {
      print $"(ansi cyan)Removing extension ($uuid)...(ansi reset)"
      strict {
        ^rm -r $ext_path
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
