use common.nu *

def copy_files [copy: record<source: string, target: string>, base: path] {
    validate_params $copy ["source", "target"]

    let source = [$base 'files' $copy.source] | path join
    let target = $copy.target

    #
    # We strictly check that we do not overwrite any target file,
    # i.e. we do not overwrite anything that comes from the stable stage
    # or from the original bluefin build
    #
    let is_dir = ($source | path type) == "dir"
    let files  = if $is_dir { glob $"($source)/**/*" } else { [$source] }

    let conflicts = ($files | where {|f| ($f | path type) == "file" } | each {|f|
        let rel_file = if $is_dir { $f | path relative-to $source } else { $f | path basename }
        $target | path join $rel_file
    } | where {|f| $f | path exists })

    if not ($conflicts | is-empty) {
        error make { msg: $"[FILES CONFLICT] Files already exists in the image: ($conflicts)" }
    }

    print $"(ansi cyan)Syncing: ($source) -> ($target)(ansi reset)"

    if not ($target | path exists) {
        strict {
          ^mkdir -p $target
        }
    }

    strict {
        # nushell's/coureutils cp has a bug that doesn't copy contents of the folder correctly
        # https://github.com/uutils/coreutils/issues/6671
        ^cp -rfv $"($source)/." $target
    }
}

def main [--base: path, --recipe-name: string, nuon: string] {
    let params = ($nuon | from nuon)
    validate_params $params ["copy"]

    $params.copy | each {
      copy_files $in $base
    } | ignore
}
