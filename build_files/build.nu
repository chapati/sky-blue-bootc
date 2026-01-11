#!/ctx/nu-shell/nu
def run_module [mod_type: string, params: record] {
    print $"Running module: ($mod_type)"
    print $"With params: ($params)"
}

def process_recipe [file_path: path] {
    print $"processing recipe ($file_path)"
    let recipe = open --raw $file_path | from yaml

    print $"(ansi cyan)Name:(ansi reset) ($recipe.name)"
    print $"(ansi cyan)Description:(ansi reset) ($recipe.description)"

    $recipe.modules | each { 
        let type   = $in.type
        let params = ($in | reject type)
        run_module $type $params
    } | ignore
}

def main [--recipe: path] {
    if ($recipe == null) {
        error make {msg: "Please provide --recipe <path>"}
    }

    print $"(ansi green)[build.nu] started(ansi reset)"
    process_recipe $recipe
    print $"(ansi green)[build.nu] finished(ansi reset)"
}
