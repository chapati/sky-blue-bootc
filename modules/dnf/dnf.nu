use common.nu *

def install_pkgs [install: list<string>] {
    if ($install | is-empty) {
        die "No packages specified for installation."
    }
        
    print $"Installing: ($install)"
    strict {
      dnf install -y ...$install
    }
}

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)      
    validate_params $params ["install"]

    install_pkgs $params.install
}
