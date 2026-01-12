use common.nu strict

# Force ANSI coloring on, so Docker doesn't strip it
$env.config.use_ansi_coloring = true

def run_module [type: string, params: record, modules_dir: path] {
    print $"(ansi green)============================= Start module ($type) =============================(ansi reset)"    
    print $"With params: ($params)"

    let module_path = ($modules_dir | path join $type $"($type).nu")
    if not ($module_path | path exists) {
        error make {msg: $"Module script not found at: ($module_path)"}
    }

    let json_payload = ($params | to json --raw)
    try {
        ^$nu.current-exe --config $nu.config-path $module_path $json_payload
    } catch {
        print --stderr $"(ansi red)× Module '($type)' failed with exit code ($env.LAST_EXIT_CODE)(ansi reset)"
        exit 1
    }

    print $"(ansi green)============================= End module ($type) =============================(ansi reset)"
}

def process_recipe [recipe_path: path, modules_dir: path] {
    print $"(ansi green)Processing recipe ($recipe_path)(ansi reset)"
    
    if not ($recipe_path | path exists) {
        error make {msg: $"Recipe file not found at: ($recipe_path)"}
    }

    let recipe = open --raw $recipe_path | from yaml
    print $"(ansi cyan)Name:(ansi reset) ($recipe.name)"
    print $"(ansi cyan)Description:(ansi reset) ($recipe.description)"
    print $"(ansi cyan)Using modules from:(ansi reset) ($modules_dir)"

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
    process_recipe $recipe $modules

    print $"(ansi cyan)[build.nu] cleaning up(ansi reset)"
    strict {
        rm -rf /tmp/* /var/*
    }

    print $"(ansi green)[build.nu] finished(ansi reset)"
}
