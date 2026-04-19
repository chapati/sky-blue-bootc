print $"(ansi green)-- System setup flatpak hook --(ansi reset)"

let flatpak_config_path = "/usr/share/sblue/flatpak.json"

if not ($flatpak_config_path | path exists) {
  print "No configuration file found. Nothing to process."
  return
}

let to_remove = open $flatpak_config_path | get remove

if ($to_remove | is-empty) {
  print "The removal list is empty."
  return
} else {
  $to_remove | each {
    print $"(ansi cyan)Removing ($in)...(ansi reset)"
    
    # Ignore errors, we do not want the whole system setup script
    # to fail just because of flatpaks. Also they might be 
    # already uninstalled.
    try {
      ^flatpak uninstall --system --noninteractive -y $in
    }
  }
}

print $"(ansi cyan)Pruning unused flatpak runtimes(ansi reset)"
try {
  ^flatpak uninstall --system --noninteractive --unused -y
}
