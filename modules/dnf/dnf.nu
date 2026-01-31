use common.nu *

def install_pkgs [install: list<string>] {
    if ($install | is-empty) {
        die "No packages specified for installation"
    }
        
    print $"Installing: ($install)"
    strict {
      ^dnf install -y ...$install
    }
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
