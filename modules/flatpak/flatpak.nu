use common.nu *

let flatpak_config_path = "/usr/share/sblue/flatpak.json"

def ensure_config [] {
    if not ($flatpak_config_path | path exists) {
        strict {^mkdir -p ($flatpak_config_path | path dirname)}
        { install: [], remove: [] } | save $flatpak_config_path
    }
}

def install_pkgs [pkgs: list<string>] {
   if ($pkgs | is-empty) {
        die "No packages specified for install"
    }

    # Ensure the file exists / create a default structure
    ensure_config

    # Read, append, and save
    open $flatpak_config_path
        | update install { append $pkgs | uniq }
        | save -f $flatpak_config_path
}

def remove_pkgs [pkgs: list<string>] {
    if ($pkgs | is-empty) {
        die "No packages specified for removal"
    }

    # Ensure the file exists / create a default structure
    ensure_config

    # Read, append, and save
    open $flatpak_config_path
        | update remove { append $pkgs | uniq }
        | save -f $flatpak_config_path
}

def main [nuon: string, --recipe-name: string, --base: path] {
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
