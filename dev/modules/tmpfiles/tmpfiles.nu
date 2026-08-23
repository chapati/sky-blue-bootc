use common.nu *

def write_tmpfile [dir: path, name: string, raw_rules: any] {
  let rules = if ($raw_rules | describe | str starts-with "string") {
    $raw_rules | lines
  } else {
    $raw_rules
  }

  if ($rules | is-empty) {
    die $"Tmpfiles rules list is empty in ($name)"
  }

  let target = [$dir, $"200-sky-blue-($name).conf"] | path join
  if ($target | path exists) {
    die $"Tmpfile already exist ($target)"
  }

  strict {
    ^mkdir -p $dir
  }

  $"($rules | str join "\n")\n" | save -f $target
  print $"(ansi cyan)Tmpfile ($target) successfully saved(ansi reset)"
}

def main [--base: path, --recipe-name: string, nuon: string] {
  let params = ($nuon | from nuon)
  validate_params $params ["user", "system"]

  let system  = $params.system?
  if $system != null {
    write_tmpfile "/usr/lib/tmpfiles.d" $recipe_name $system
  }

  let user  = $params.user?
  if $user != null {
    write_tmpfile "/usr/share/user-tmpfiles.d" $recipe_name $user
  }
}
