use common.nu *

def main [nuon: string, --base: path] {
    let params = ($nuon | from nuon)        
    validate_params $params ["snippets"]
    
    $params.snippets | each {
      strict {
        ^bash -c $in
      }
    } | ignore 
}
