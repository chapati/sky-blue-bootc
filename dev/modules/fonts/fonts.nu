use common.nu *

def install_zip_url [url: string, target_dir: path, dir_name: string] {
  let tmp_zip = $"/tmp/($dir_name).zip"
  print $"(ansi cyan)Installing zip font ($dir_name) -> ($target_dir)(ansi reset)"

  strict {
    ^curl -fsSL $url -o $tmp_zip
    ^mkdir -p $target_dir
    ^unzip -q -o $tmp_zip -d $target_dir
    ^rm -f $tmp_zip
    ^find $target_dir -type f -exec chmod 644 {} +
    ^find $target_dir -type d -exec chmod 755 {} +
  }
}

def install_file_url [url: string, target_dir: path, filename: string] {
  let target_file = [$target_dir, $filename] | path join
  print $"(ansi cyan)Installing font file ($filename) -> ($target_file)(ansi reset)"

  strict {
    ^mkdir -p $target_dir
    ^curl -fsSL $url -o $target_file
    ^chmod 644 $target_file
    ^chmod 755 $target_dir
  }
}

def install_font_entry [entry: record] {
  validate_params $entry ["url", "folder"]

  let url = $entry.url
  let folder = $entry.folder

  let clean_url = ($url | split row '?' | get 0)
  let filename = ($clean_url | path basename)
  let parsed = ($filename | path parse)

  let ext = ($parsed.extension | str lowercase)
  let target_dir = $"/usr/share/fonts/($folder)"

  if ($target_dir | path exists) {
    error make { msg: $"[FONT CONFLICT] Font target directory already exists: ($target_dir)" }
  }

  match $ext {
    "zip" => {
      install_zip_url $url $target_dir $folder
    }
    "ttf" | "otf" | "woff" | "woff2" => {
      install_file_url $url $target_dir $filename
    }
    _ => {
      error make { msg: $"[FONT ERROR] Unsupported file type '.($ext)' for URL: ($url)" }
    }
  }
}

def main [--base: path, --recipe-name: string, nuon: string] {
  let params = ($nuon | from nuon)
  validate_params $params ["fonts"]

  $params.fonts | each {|entry|
    install_font_entry $entry
  } | ignore

  print $"(ansi green)Updating system font cache...(ansi reset)"
  strict {
    ^fc-cache -f
  }
}