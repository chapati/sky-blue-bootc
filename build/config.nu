print $"($nu.config-path)"

$env.NU_LIB_DIRS = [ 
  ($nu.config-path | path dirname | path join "lib") 
]

print $"NU_LIB_DIRS: ($env.NU_LIB_DIRS)"