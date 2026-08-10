use common.nu *

let exts_dir = "/usr/share/gnome-shell/extensions"

def remove_exts [remove: list<string>] {
  if ($remove | is-empty) {
    die "No extensions specified for removal"
  }

  $remove | each { |uuid|
    let ext_path = [$exts_dir $uuid] | path join
    if ($ext_path | path exists) {
      print $"(ansi cyan)Removing extension ($uuid)(ansi reset)"
      strict {
        ^rm -r $ext_path
      }
    } else {
      print $"Extension ($uuid) is not installed, skipping."
    }
  } | ignore
}

def install_exts [install: list<any>] {
  if ($install | is-empty) {
    die "No extensions specified for installation"
  }

  $install | each { |uuid|
    let tmp_dir = (mktemp -d)
    let zip_path = [$tmp_dir "ext.zip"] | path join
    let extract_dir = [$tmp_dir "extracted"] | path join
    let shell_ver = strict {^gnome-shell --version | parse "GNOME Shell {ver}" | get ver.0 | split row "." | first} true

    strict {
      ^mkdir $extract_dir
    }

    let dl_url = $"https://extensions.gnome.org/download-extension/($uuid).shell-extension.zip?shell_version=($shell_ver)"
    print $"(ansi cyan)Downloading ($uuid)...(ansi reset)"

    strict {
      ^curl -sSL $dl_url -o $zip_path
      ^unzip -q -o $zip_path -d $extract_dir
    }

    let meta_files = (glob $"($extract_dir)/**/metadata.json")
    if ($meta_files | is-empty) {
      die $"Invalid extension archive for ($uuid): missing metadata.json"
    }

    let src_dir = ($meta_files | first | path dirname)
    let dest_dir = [$exts_dir $uuid] | path join

    print $"(ansi green)Installing ($uuid) to ($dest_dir)(ansi reset)"
    strict {
      ^rm -rf $dest_dir
      ^mkdir $dest_dir
      ^cp -r $"($src_dir)/." $dest_dir
      ^chmod -R a+rX $dest_dir
    }

    let schema_dir = [$dest_dir "schemas"] | path join
    if ($schema_dir | path exists) {
      print $"(ansi cyan)Compiling schemas for ($uuid)...(ansi reset)"
      strict {
        ^glib-compile-schemas $schema_dir
      }
    }

    rm -rf $tmp_dir
  } | ignore
}

def main [nuon: string, --base: path] {
  let params = ($nuon | from nuon)
  validate_params $params ["install", "remove"]

  let install = ($params | get -o install)
  if $install != null {
    install_exts $install
  }

  let remove = ($params | get -o remove)
  if $remove != null {
    remove_exts $remove
  }
}
