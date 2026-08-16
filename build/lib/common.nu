export def strict [cmd: closure, result: bool = false] {
    let res = try {
        $env.LAST_EXIT_CODE = 0
        let val = (do $cmd)

        if ($env.LAST_EXIT_CODE? | default 0) != 0 {
            error make { msg: $"External command failed with exit code ($env.LAST_EXIT_CODE)" }
        }

        {failed: false, result: $val}
    } catch { |err|
        {failed: true, error: $err}
    }

    if $res.failed {
        let err = $res.error
        let msg = $err.msg? | default "Strict closure execution failed"
        error make {
            msg: $msg
            labels: [{
                text: ($err.labels?.0?.text? | default "failed here")
                span: ($err.labels?.0?.span? | default (metadata $cmd))
            }]
        }
    } else if $result {
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

export def is_dev []: nothing -> bool {
    ($env.DEV_MODE? | default "false") in ["true" "1" "yes"]
}
