export def strict [cmd: closure] {
    do $cmd
    let code = $env.LAST_EXIT_CODE
    if ($code != 0) {
        error make {
            msg: $"(ansi red)Command ($cmd) failed with exit code ($code)(ansi reset)"
        }
    }
}

export def die [msg: string] {
    error make {
        msg: $"(ansi red)× ($msg)(ansi reset)"
    }
}

export def validate_params [params: record, allowed_keys: list<string>] {
    let input_keys = ($params | columns)
    let invalid_keys = ($input_keys | where {|k| $k not-in $allowed_keys })

    if not ($invalid_keys | is-empty) {
        die $"Unknown parameters: ($invalid_keys). Allowed: ($allowed_keys)"
    }

    if ($input_keys | is-empty) {
        die "No valid parameters provided."
    }
}

export def validate_list [params: list<string>,  allowed_keys: list<string>] {
    $params | each {
        if $in not-in $allowed_keys {
            die $"Invalid parameter found: '($in)'. Allowed values are: ($allowed_keys | str join ', ')"
        }
    } | ignore
}
