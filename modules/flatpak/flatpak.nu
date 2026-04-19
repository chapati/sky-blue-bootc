use common.nu *

let flatpak_config_path = "/usr/share/sblue/flatpak.json"

def install_pkgs [install: list<string>] {
    if ($install | is-empty) {
        die "No packages specified for installation"
    }
        
    print $"(ansi cyan)Installing flatpaks: ($install)(ansi reset)"
    
    # We use --system to ensure global installation (usually /var/lib/flatpak)
    # --noninteractive is crucial for CI/CD to prevent prompts
    strict {
      ^flatpak install --system --noninteractive -y ...$install
    }
}

def remove_pkgs [pkgs: list<string>] {
    if ($pkgs | is-empty) {
        die "No packages specified for removal"
    }

    # Ensure the file exists, or create a default structure
    if not ($flatpak_config_path | path exists) {
        { remove: [] } | save $flatpak_config_path
    }

    # Read, append, and save
    open $flatpak_config_path 
        | update remove { append $pkgs | uniq }
        | save -f $flatpak_config_path
}

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)        
    validate_params $params ["remove", "install"]
    
    let remove  = ($params | get -o remove)
    if $remove != null {
        remove_pkgs $params.remove
    }

    let install = ($params | get -o install)
    if $install != null {
        install_pkgs $params.install
    }
}
