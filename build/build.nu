use common.nu *

def run_module [type: string, params: record, base_dir: path] {
    print $"(ansi green)============================= Start module ($type) =============================(ansi reset)"    
    print $"(ansi cyan)With params:(ansi reset) ($params)"

    let module_path = [$base_dir "modules" $type $"($type).nu"] | path join
    print $"(ansi cyan)Module path:(ansi reset) ($module_path)"

    if not ($module_path | path exists) {
       die $"Module script not found at: ($module_path)"
    }

    try {
        let payload = $params | to nuon
        ^$nu.current-exe --config $nu.config-path $module_path --base $base_dir $payload
    } catch {
        print --stderr $"(ansi red)× Module '($type)' failed with exit code ($env.LAST_EXIT_CODE)(ansi reset)"
        print --stderr $"============================= (ansi red)Failed module ($type)(ansi reset) ============================="
        exit 1
    }

    print $"(ansi green)============================= End module ($type) =============================(ansi reset)"
}

def process_recipe [recipe_path: path, base_dir: path] {
    print $"(ansi green)Processing recipe:(ansi reset) ($recipe_path)"
    
    if not ($recipe_path | path exists) {
        die $"Recipe file not found at: ($recipe_path)"
    }

    let recipe = open --raw $recipe_path | from yaml
    print $"(ansi cyan)Name:(ansi reset) ($recipe.name)"
    print $"(ansi cyan)Description:(ansi reset) ($recipe.description)"
    print $"(ansi cyan)Base:(ansi reset) ($base_dir)"

    $recipe.modules | each { 
        if ($in | get -o include) != null {
            let from_file = $in.include
            let recipe_dir = $recipe_path | path dirname
            let sub_recipe = [$recipe_dir $from_file] | path join
            print $"(ansi yellow)Including sub-recipe from file: ($sub_recipe)(ansi reset)"
            process_recipe $sub_recipe $base_dir
        } else if ($in | get -o type) != null {
            let type = $in.type
            let params = ($in | reject type)
            run_module $type $params $base_dir
        } else {
            die $"Invalid module entry in recipe: ($in)"   
        }
    } | ignore
}

def copy_libs [base_path: path] {
    print $"(ansi green)Copying nushel libs to the target system(ansi reset)"

    let lib_src = [$base_path "lib"] | path join
    if not ($lib_src | path exists) {
        die $"Library directory not found at: ($lib_src)"
    }

    let lib_dst = "/usr/libexec/sblue/lib/"
    strict {
        ^mkdir -p $lib_dst
        ^cp -rfv $"($lib_src)/." $lib_dst
    }

    let config_src = [$base_path "config.nu"] | path join
    if not ($config_src | path exists) {
        die $"Config file not found at: ($config_src)"  
    }

    let config_dst = "/usr/libexec/sblue/config.nu"
    strict {
        ^cp -fv $config_src $config_dst
    }
}

def main [--recipe: path, --base: path] {
    if ($recipe == null) {
        die "Missing required flag: --recipe <path>"
    }

    if ($base == null) {
        die "Missing required flag: --base <path>"
    }

    print $"(ansi green)[build.nu] started(ansi reset)"   

    # Copy libraries to the target system
    copy_libs $base
    
    # Process main recipe
    process_recipe $recipe $base

    print $"(ansi green)[build.nu] finished(ansi reset)"
}
