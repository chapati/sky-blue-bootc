use common.nu *

def install_rpm [item: record, base: path] {
  validate_params $item ["url", "key", "sha256", "options"]

  let tmp_file = (mktemp --tmpdir "pkg_XXXXXX.rpm")

  if ($item.key? | is-not-empty) {
    let key_path = [$base 'files' 'keys' $item.key] | path join

    if not ($key_path | path exists) {
      error make { msg: $"[RPM] GPG key not found: ($key_path)" }
    }

    print $"(ansi cyan)Importing GPG key: ($key_path)(ansi reset)"
    strict { ^rpm --import $key_path }
  }

  print $"(ansi cyan)Downloading: ($item.url)(ansi reset)"
  strict {
    ^curl --connect-timeout 10 -fsSL --connect-timeout 10 -o $tmp_file $item.url
  }

  # Validate checksum
  let computed_hash = (open --raw $tmp_file | hash sha256)
  if ($computed_hash != ($item.sha256 | str trim | str lowercase)) {
    error make {
      msg: $"[RPM SHA256 MISMATCH] ($item.url)\n  Expected: ($item.sha256)\n  Computed: ($computed_hash)"
    }
  }

  # Assert signature against imported keyring if key was specified
  if ($item.key? | is-not-empty) {
    strict { ^rpm -K $tmp_file }
  }

  # Parse and validate options against supported flags
  let extra_flags = ($item.options? | default [] | each {|opt|
    match $opt {
      "noscripts" => "--noscripts",
      "nodeps"    => "--nodeps",
      _ => {
        error make { msg: $"[RPM] Unsupported option: '($opt)'" }
      }
    }
  })

  print $"(ansi cyan)Installing: ($item.url)(ansi reset)"
  strict {
    ^rpm -Uvh ...$extra_flags $tmp_file
    ^rm -f $tmp_file
  }
}

def main [--base: path, --recipe-name: string, nuon: string] {
  let params = ($nuon | from nuon)
  validate_params $params ["install"]

  $params.install | each {
    install_rpm $in $base
  } | ignore
}
