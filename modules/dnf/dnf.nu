use common.nu *

def install_packages [names: list<string>, ignore_errors: bool] {
    if ($names | is-empty) {
        die "No packages specified for installation"
    } 

    if $ignore_errors {
        print $"(ansi yellow)Installing ($names) ignoring errors...(ansi reset)"
        try {
            ^dnf install -y ...$names
        } catch {
            print $"(ansi yellow)Warning: finished with errors.(ansi reset)"
        }
    } else {
        print $"(ansi cyan)Installing ($names)...(ansi reset)"
        strict {
            ^dnf install -y ...$names
        }
    }
}

def install_pkgs [install: list<any>] {
    if ($install | is-empty) {
        die "No packages specified for installation"
    }

    # N.B. preserve the order of fields in opts to ensure consistent grouping in batches
    let parsed = $install | each {
        match $in {
            $name if ($name | describe) == "string" => {
                {
                    name: $name, 
                    opts: { 
                        ignore_errors: false 
                    }
                }
            }

            {name: $name, options: $options} => {
                if ($options | describe) != "list<string>" {
                    die $"Field 'options' must be a list of strings, got ($options | describe) in package ($name)"
                }

                validate_list $options ["ignore-errors"]

                {   
                    name: $name, 
                    opts: { 
                        ignore_errors: ("ignore-errors" in $options) 
                    } 
                }
            }

            _ =>  {
                die $"Unsupported install specification: ($in)"
            }
        }
    } 

    let batches = ($parsed 
        | group-by { $in.opts | to nuon } 
        | values 
        | each {
            let first = $in | first
            {
                packages: $in.name,
                ignore_errors: $first.opts.ignore_errors
            }
        }
    )

    $batches | each {
        install_packages $in.packages $in.ignore_errors
    } | ignore
}

def enable_repos [repos: list<string>, base: path] {
    if ($repos | is-empty) {
        die "No repos specified for installation"
    }

    $repos | each {
        let repo_file = [$base 'files' 'dnf' $in] | path join
        print $"(ansi cyan)Adding repo:(ansi reset) ($repo_file)"

        strict {
          ^cp -vf $repo_file /etc/yum.repos.d/
        }

        let repo_id = ($in | path parse | get stem)

        try {
            ^dnf config-manager --set-enabled $repo_id
        } catch {
            # most likely it is enabled already
            # so just ignore any errors here
        }
    } | ignore
}

def cleanup_repos [repos: list<string>] {
    if ($repos | is-empty) {
        die "No repos specified for cleanup"
    }

    $repos | each {
        print $"(ansi cyan)Removing repo: ($in)(ansi reset)"
        let target = ["/etc/yum.repos.d/" $in] | path join
        strict { 
            ^rm -f $target 
        }
    } | ignore
}

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)        
    validate_params $params ["install", "repos"]
    
    let repos = ($params | get -o repos)
    if $repos != null {
        enable_repos $params.repos $base
    }

    install_pkgs $params.install

    if $repos != null {
        cleanup_repos $params.repos
    }
}
