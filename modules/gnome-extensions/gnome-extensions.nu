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

def enable_extensions [extensions: list<string>] {
  if ($extensions | is-empty) {
    return
  }

  let distro_dir = "/etc/dconf/db/distro.d"
  let keyfile = [$distro_dir "60-extensions"] | path join
  let bluefin_override = "/usr/share/glib-2.0/schemas/zz0-bluefin-modifications.gschema.override"

  let bluefin_line = (
    open $bluefin_override
    | lines
    | where { |l| $l | str contains "enabled-extensions" }
  )

  if ($bluefin_line | is-empty) {
    die $"enabled-extensions key not found in '($bluefin_override)'"
  }

  let array_str = ($bluefin_line | first | split row "=" | last | str trim)
  let bluefin_uuids = ($array_str | from nuon)
  if ($bluefin_uuids | is-empty) {
    die $"Failed to parse UUIDs from '($bluefin_override)'"
  }

  let all_uuids = ($bluefin_uuids | append $extensions | uniq)
  let formatted_list = ($all_uuids | each { |u| $"'($u)'" } | str join ", ")
  let dconf_content = $"[org/gnome/shell]\nenabled-extensions=[($formatted_list)]\n"

  mkdir $distro_dir
  print $"(ansi cyan)Setting default enabled extensions in ($keyfile)...(ansi reset)"
  $dconf_content | save -f $keyfile
}

def main [nuon: string, --base: path] {
  let params = ($nuon | from nuon)
  validate_params $params ["install", "remove", "enable"]

  let install = ($params | get -o install)
  if $install != null {
    install_exts $install
  }

  let enable = ($params | get -o enable)
  if $enable != null {
    enable_exts $enable
  }

  let remove = ($params | get -o remove)
  if $remove != null {
    remove_exts $remove
  }
}
