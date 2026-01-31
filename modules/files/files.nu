use common.nu *

def copy_files [copy: record<source: string, target: string>, base: path] { 
    validate_params $copy ["source", "target"]

    let source = $base | path join 'files' $copy.source
    let target = $copy.target

    print $"(ansi cyan)Syncing: ($source) -> ($target)(ansi reset)"

    if not ($target | path exists) {
        strict {
          mkdir $target # mkdir in nushell is -p by default
        }
    }

    strict {
        cp -rfv $"($source)/." $target
    }
}

def main [--base: path, nuon: string] {
    let params = ($nuon | from nuon)  
    validate_params $params ["copy"]

    $params.copy | each { 
      copy_files $in $base
    } | ignore
}
