use common.nu *

def fetch_git_repo [entry: record] {
  validate_params $entry ["target", "url", "hash"]

  let target_dir = $entry.target
  let url = $entry.url
  let hash = $entry.hash
  let git_dir = [$target_dir, ".git"] | path join

  if ($target_dir | path exists) {
    die $"Target directory already exists ($target_dir)"
  }

  print $"(ansi cyan)Fetching git repo ($url) @ ($hash) -> ($target_dir)(ansi reset)"

  strict {
    ^mkdir -p $target_dir
    ^git -C $target_dir init -q
    ^git -C $target_dir fetch -q --depth 1 $url $hash
    ^git -C $target_dir reset -q --hard FETCH_HEAD
    ^rm -rf $git_dir
  }
}

def main [--base: path, --recipe-name: string, nuon: string] {
  let params = ($nuon | from nuon)
  validate_params $params ["fetch"]

  $params.fetch | each {|entry|
    fetch_git_repo $entry
  } | ignore

  print $"(ansi green)Git repositories fetched successfully.(ansi reset)"
}
