def main [json_payload: string] {
    let params = ($json_payload | from json)

    # Extract the list of packages
    # Using 'get' with '?' allows it to return null if the key is missing
    let packages = ($params | get -i install)

    if ($packages == null) or ($packages | is-empty) {
        print $"(ansi yellow)Warning: No packages defined under 'install' key.(ansi reset)"
        return
    }

    print $"(ansi cyan)Installing ($packages | length) packages: ($packages | str join ', ')(ansi reset)"

    # The '...' spread operator expands the list into individual arguments
    dnf install -y ...$packages
}
