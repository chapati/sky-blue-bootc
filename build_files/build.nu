#!/ctx/nu-shell/nu
def run_module [type: string, params: record, modules_dir: path] {
    print $"(ansi green)============================= Start module ($type) =============================(ansi reset)"    
    print $"With params: ($params)"

    let module_path = ($modules_dir | path join $type $"($type).nu")
    if not ($module_path | path exists) {
        error make {msg: $"Module script not found at: ($module_path)"}
    }

    let json_payload = ($params | to json --raw)
    ^$nu.current-exe $module_path $json_payload

    print $"(ansi green)============================= End module ($type) =============================(ansi reset)"
}

def process_recipe [recipe_path: path, modules_dir: path] {
    print $"(ansi green)Processing recipe ($recipe_path)(ansi reset)"
    
    let recipe = open --raw $recipe_path | from yaml
    print $"(ansi cyan)Name:(ansi reset) ($recipe.name)"
    print $"(ansi cyan)Description:(ansi reset) ($recipe.description)"

    $recipe.modules | each { 
        let type   = $in.type
        let params = ($in | reject type)
        run_module $type $params $modules_dir
    } | ignore
}

def main [--recipe: path, --modules: path] {
    if ($recipe == null) {
        error make {msg: "Missing required flag: --recipe <path>"}
    }

    if ($modules == null) {
        error make {msg: "Missing required flag: --modules <path>"}
    }

    print $"(ansi green)[build.nu] started(ansi reset)"
    print $"using modules from: ($modules)"
    process_recipe $recipe $modules
    print $"(ansi green)[build.nu] finished(ansi reset)"
}
