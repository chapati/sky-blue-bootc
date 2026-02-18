use common.nu *

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

def remove_pkgs [remove: list<string>] {
    if ($remove | is-empty) {
        die "No packages specified for removal"
    }

    print $"(ansi cyan)Removing flatpaks: ($remove)(ansi reset)"
    
    strict {
      ^flatpak uninstall --system --noninteractive -y ...$remove
    }

    print $"(ansi cyan)Pruning unused flatpak runtimes(ansi reset)"
    try {
        ^flatpak uninstall --system --noninteractive --unused -y
    }
}

def setup_service [] {
    print $"(ansi cyan)Setting up flatpak service(ansi reset)"    
    
    const script_dir = "/usr/libexec/sblue/flatpaks"
    const script_name = "sblue-flatpaks.nu"

    let script_src = [$env.FILE_PWD, "post-boot", $script_name] | path join
    let script_dst = [$script_dir, $script_name] | path join
    
    strict {
        ^mkdir -p $script_dir
        ^cp $script_src $script_dst
        ^chmod +x $script_dst
    }   

    const unit_dir = "/usr/lib/systemd/system/"
    const service_name = "sblue-flatpaks.service"

    let unit_src = [$env.FILE_PWD, "post-boot", $service_name] | path join
    let unit_dst = [$unit_dir, $service_name] | path join
    
    strict {
        ^mkdir -p $unit_dir
        ^cp $unit_src $unit_dst
        ^systemctl enable --force $service_name
    }
}

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)        
    validate_params $params ["remove", "install"]
    
    setup_service

    let remove  = ($params | get -o remove)
    if $remove != null {
        remove_pkgs $params.remove
    }

    let install = ($params | get -o install)
    if $install != null {
        install_pkgs $params.install
    }
}
