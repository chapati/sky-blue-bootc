$env.NU_LIB_DIRS = [ 
  ($nu.config-path | path dirname | path join "lib") 
]
