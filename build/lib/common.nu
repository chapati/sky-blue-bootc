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
