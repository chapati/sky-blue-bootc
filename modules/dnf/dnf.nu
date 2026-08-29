use common.nu *

def install_packages [names: list<string>, ignore_errors: bool] {
    if ($names | is-empty) {
        die "No packages specified for installation"
    }

    # Flags to keep layers minimal:
    # - install_weak_deps=False: skips recommended/weak deps
    # - --nodocs: skips man pages, docs, and licenses
    let dnf_flags = [
        "-y"
        "--nodocs"
        "--setopt=install_weak_deps=False"
    ]

    if $ignore_errors {
        print $"(ansi yellow)Installing ($names) ignoring errors...(ansi reset)"
        try {
            ^dnf install ...$dnf_flags ...$names
        } catch {
            print $"(ansi yellow)Warning: finished with errors.(ansi reset)"
        }
    } else {
        print $"(ansi cyan)Installing ($names)...(ansi reset)"
        strict {
            ^dnf install ...$dnf_flags ...$names
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

def remove_packages [names: list<string>, ignore_errors: bool] {
    if ($names | is-empty) {
        die "No packages specified for removal"
    }

    # Flags to cascade-remove orphan dependencies:
    # - clean_requirements_on_remove=True removes all unused deps
    let dnf_flags = [
        "-y"
        "--setopt=clean_requirements_on_remove=True"
    ]

    if $ignore_errors {
        print $"(ansi yellow)Removing ($names) ignoring errors...(ansi reset)"
        try {
            ^dnf remove ...$dnf_flags ...$names
        } catch {
            print $"(ansi yellow)Warning: finished with errors.(ansi reset)"
        }
    } else {
        print $"(ansi cyan)Removing ($names)...(ansi reset)"
        strict {
            ^dnf remove ...$dnf_flags ...$names
        }
    }
}

def remove_pkgs [remove: list<any>] {
    if ($remove | is-empty) {
        die "No packages specified for installation"
    }

    # N.B. preserve the order of fields in opts to ensure consistent grouping in batches
    let parsed = $remove | each {
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
        remove_packages $in.packages $in.ignore_errors
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
            ^dnf config-manager enable $repo_id
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

def main [nuon: string, --recipe-name: string, --base: path] {
    let params = ($nuon | from nuon)
    validate_params $params ["install", "remove", "repos"]

    let repos = ($params | get -o repos)
    if $repos != null {
        enable_repos $params.repos $base
    }

    let install = ($params | get -o install)
    if $install != null {
        install_pkgs $install
    }

    let remove = ($params | get -o remove)
    if $remove != null {
        remove_pkgs $remove
    }

    if $repos != null {
        cleanup_repos $params.repos
    }
}
