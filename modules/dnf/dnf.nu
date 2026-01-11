def install_pkgs [install: list<string>]{
    if ($install | length) == 0 {
        return
    }
        
    print $"Installing: ($install)"
    dnf install -y ...$install
}

def main [json_payload: string] {
    let params = $json_payload 
      | from json
      | default [] install
    
    install_pkgs $params.install
}
