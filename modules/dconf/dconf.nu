use common.nu *

def format-gvariant [val: any, val_type: string] {
  match ($val_type | str lowercase) {
    "string" => $"'($val)'"
    "boolean" | "bool" => ($val | into string | str lowercase)
    "int" | "integer" => ($val | into string)
    "double" | "float" | "number" => ($val | into string)
    "array" | "list" => {
      # If $val is a single scalar item instead of a list, wrap it directly
      if not ($val | describe | str starts-with "list") {
        return $"[($val)]"
      }

      # Format each element in the list based on its type
      let items = $val | each { |item|
        if ($item | describe) == "string" {
          $"'($item)'"
        } else {
          $"($item)"
        }
      } | str join ", "

      $"[($items)]"
    }
    _ => $"($val)"
  }
}

def parse-dconf-entry [entry: record] {
  let clean_path = ($entry.key | str trim --char '/')
  let parts = ($clean_path | split row '/')

  return {
    section: ($parts | drop 1 | str join '/'),
    key: ($parts | last),
    value: (format-gvariant $entry.value $entry.type)
  }
}

def build-keyfile [entries: list] {
    $entries
    | group-by section
    | items { |section, items|
      let lines = ($items | each { |i| $"($i.key)=($i.value)" } | str join "\n")
      $"[($section)]\n($lines)"
    }
    | str join "\n\n"
}

def main [--base: path, --recipe-name: string, nuon: string] {
  let params = ($nuon | from nuon)
  validate_params $params ["distro.d"]

  # Parse entries and format keyfile content
  let entries = ($params."distro.d" | each { |entry| parse-dconf-entry $entry })
  let ini_content = (build-keyfile $entries)

  # Determine target directory and filename derived from recipe name
  let target_dir = "/etc/dconf/db/distro.d"
  let output_file = [$target_dir $"200-sblue-($recipe_name)"] | path join

  if ($output_file | path exists) {
    die $"Dconf file already exists: ($output_file)"
  }

  strict {
    ^mkdir -p $target_dir
  }

  $ini_content | save $output_file
  print $"(ansi green)Successfully created dconf file:(ansi reset) ($output_file)"
}
