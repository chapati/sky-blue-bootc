print $"(ansi green)-- System setup flatpak hook --(ansi reset)"

# print $"(ansi cyan)Removing flatpaks: ($remove)(ansi reset)"

# strict {
#   ^flatpak uninstall --system --noninteractive -y ...$remove
# }

# print $"(ansi cyan)Pruning unused flatpak runtimes(ansi reset)"
# try {
#     ^flatpak uninstall --system --noninteractive --unused -y
# }