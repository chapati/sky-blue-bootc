use common.nu *

def register_service [service_name: string, scope: string, base_path: path] { 
    if $scope == "system" {
        print $"(ansi green)Registering system service:(ansi reset) ($service_name)"
    } else if $scope == "user" {
        print $"(ansi green)Registering user service:(ansi reset) ($service_name)"
    } else {
        die $"Invalid scope: ($scope) for service ($service_name). Expected 'system' or 'user'."
    }
    
    let script_name = $"($service_name).nu"
    let script_src = [$base_path, "files", "service", $script_name] | path join
    let script_dst = ["/usr/libexec/sblue/", $script_name] | path join

    strict {
        ^mkdir -p ($script_dst | path dirname)
        ^cp -fv $script_src $script_dst
    }
    
    let unit_dir = if $scope == "system" {"/usr/lib/systemd/system/"} else {"/usr/lib/systemd/user/"}
    let service_name = $"($service_name).service"

    let unit_src = [$base_path, "files", "service", $service_name] | path join
    let unit_dst = [$unit_dir, $service_name] | path join
    
    strict {
        ^mkdir -p ($unit_dst | path dirname)
        ^cp -fv $unit_src $unit_dst

        if $scope == "system" {
            ^systemctl enable $service_name
        } else {
            ^systemctl --global enable $service_name
        }
    }    
}

def main [nuon: string, --base: path] {
  let params = ($nuon | from nuon)
  validate_params $params ["register"]

  let register = ($params | get -o register)
  if $register != null {
    $params.register | each {
      register_service $in.name $in.scope $base
    } | ignore
  }
}
