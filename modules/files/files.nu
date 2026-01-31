use common.nu *

def copy_files [copy: record<source: string, target: string>, base: path] { 
    validate_params $copy ["source", "target"]

    let source = [$base 'files' $copy.source] | path join
    let target = $copy.target

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

def main [--base: path, nuon: string] {
    let params = ($nuon | from nuon)  
    validate_params $params ["copy"]

    $params.copy | each { 
      copy_files $in $base
    } | ignore
}
