export def strict [cmd: closure] {
    let res = try {
        {failed: false, result: (do --env $cmd)}
    } catch { 
        {failed: true, error: $in}
    }

    if $res.failed {
        let err = ($res.error.json | from json)
        error make {
            msg: $err.msg
            label: {
                text: $err.labels.0.text,
                span: $err.labels.0.span
            }
        }
    } else {
        return $res.result
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
