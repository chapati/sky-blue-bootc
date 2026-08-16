use common.nu *

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)
    validate_params $params ["snippets"]

    $params.snippets | each {|cmd|
      print $"(ansi purple)Executing:(ansi reset) ($cmd)"
      strict {
        ^bash -c $cmd
      }
    } | ignore
}
