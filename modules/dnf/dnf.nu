use common.nu strict

def install_pkgs [install: list<string>] {
    if ($install | is-empty) {
        return
    }
        
    print $"Installing: ($install)"
    strict {
      dnf install -y ...$install
    }
}

def main [json_payload: string] {
    let params = ($json_payload 
      | from json
      | default [] install)
    
    install_pkgs $params.install
}
