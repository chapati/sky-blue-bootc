use common.nu *

const BUILTIN_DIR = "/usr/share/code/resources/app/extensions"
const EXT_DIR     = "/usr/share/code/extensions"

def install_from_files [files: list<string>, base: path] {
  if ($files | is-empty) {
      die "No files specified for VS Code extension installation"
  }

  $files | each { |file|
    let ext_name = ($file | str replace -r '\.vsix$' '')
    let vsix_path = [$base 'files' 'vscode' $"($ext_name).vsix"] | path join

    if not ($vsix_path | path exists) {
      die $"VSIX file not found: ($vsix_path)"
    }

    print $"(ansi cyan)Installing VS Code built-in extension from file: ($file)...(ansi reset)"
    let target_dir = [$BUILTIN_DIR $ext_name] | path join
    let tmp_dir = ["/tmp" $"vscode-ext-($ext_name)"] | path join

    strict {
      ^mkdir -p $target_dir $tmp_dir
      ^unzip -q $vsix_path "extension/*" -d $tmp_dir
      ^chmod -R a+rX $"($tmp_dir)/extension"
      ^cp -rf $"($tmp_dir)/extension/." $target_dir
      ^rm -rf $tmp_dir
    }
  } | ignore
}

def install_from_marketplace [extensions: list<string>] {
  if ($extensions | is-empty) {
    die "No marketplace extensions specified for installation"
  }

  let installed_folders = $extensions | each { |ext_id|
    print $"(ansi cyan)Downloading VS Code extension from Marketplace: ($ext_id)...(ansi reset)"
    let parts = ($ext_id | split row ".")
    if ($parts | length) < 2 {
      die $"Invalid extension ID format: ($ext_id). Expected 'publisher.name'."
    }

    let publisher = $parts | first
    let name = $parts | skip 1 | str join "."

    let arch = (^uname -m | str trim)
    let target_platform = (if $arch == "x86_64" { "linux-x64" } else if $arch == "aarch64" { "linux-arm64" } else { "universal" })
    let base_url = $"https://marketplace.visualstudio.com/_apis/public/gallery/publishers/($publisher)/vsextensions/($name)/latest/vspackage"
    let platform_url = $"($base_url)?targetPlatform=($target_platform)"
    let tmp_dir = ["/tmp" $"vscode-ext-($ext_id)"] | path join
    let vsix_file = [$tmp_dir "ext.vsix"] | path join

    strict {
      ^mkdir -p $tmp_dir
    }

    let download = (do { ^curl -fsSL --connect-timeout 10 --compressed $platform_url -o $vsix_file } | complete)
    if $download.exit_code != 0 {
      strict {
        ^curl -fsSL --compressed --connect-timeout 10 $base_url -o $vsix_file
      }
    }

    strict {
      ^unzip -q $vsix_file "extension/*" -d $tmp_dir
    }

    let pkg = (open $"($tmp_dir)/extension/package.json")
    let pub = ($pkg | get -o publisher | default $publisher)
    let ext_folder_name = $"($pub).($pkg.name)-($pkg.version)"
    let target_dir = [$EXT_DIR $ext_folder_name] | path join

    strict {
      ^mkdir -p $target_dir
      ^chmod -R a+rX $"($tmp_dir)/extension"
      ^cp -rf $"($tmp_dir)/extension/." $target_dir
      ^rm -rf $tmp_dir
    }

    $ext_folder_name
  }

  setup_tmpfiles $installed_folders
}

def setup_tmpfiles [ext_folder_names: list<string>] {
  if ($ext_folder_names | is-empty) {
    return
  }

  let conf_dir  = "/usr/share/user-tmpfiles.d"
  let conf_file = [$conf_dir "200-skyblue-vscode-extensions.conf"] | path join

  let base_rule = "d %h/.vscode/extensions 0755 - - -"
  let ext_rules = ($ext_folder_names | each { |folder|
    $"C+ %h/.vscode/extensions/($folder) - - - - ($EXT_DIR)/($folder)"
  })

  let rules = ([$base_rule] | append $ext_rules)
  strict {
    ^mkdir -p $conf_dir
  }

  let existing_lines = if ($conf_file | path exists) {
    open --raw $conf_file | lines
  } else {
    []
  }

  let missing_lines = ($rules | where { |line| $line not-in $existing_lines })
  if not ($missing_lines | is-empty) {
    let to_append = ($missing_lines | str join "\n") + "\n"
    $to_append | save --append $conf_file
  }
}

def main [nuon: string, --recipe-name: string, --base: path] {
  let params = ($nuon | from nuon)
  validate_params $params ["marketplace", "files"]

  let files = ($params | get -o files)
  if $files != null {
    install_from_files $files $base
  }

  let marketplace = ($params | get -o marketplace)
  if $marketplace != null {
    install_from_marketplace $marketplace
  }
}
