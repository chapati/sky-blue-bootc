use common.nu *

export def wait_service_end [service_name: string, is_system: bool, state: string, substate] {
    let scope = if $is_system {"system"} else {"user"}
    print $"(ansi green)Waiting for ($scope) service to finish:(ansi reset) ($service_name)"
    
    let get_status = if $is_system {
        {^systemctl show $"($service_name).service" --property=ActiveState,SubState}
    } else {
        {^systemctl --user show $"($service_name).service" --property=ActiveState,SubState}
    }

    loop {
      let service_info = (
        strict $get_status true
        | lines 
        | str trim
        | parse "{k}={v}" 
        | transpose -rd
      )

      if ($service_info | is-empty) {
          die $"Error: Could not retrieve status for ($service_name)"
          break
      }

      if $service_info.ActiveState == "failed" {
        die $"($service_name) failed. Unable to continue."
        break
      }
  
      if $service_info.ActiveState == $state and $service_info.SubState == $substate {
        print $"($service_name) completed."
        break
      }
    
      sleep 1sec
    }
}
