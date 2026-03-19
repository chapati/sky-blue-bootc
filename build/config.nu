$env.NU_LIB_DIRS = [ 
  ($nu.config-path | path dirname | path join "lib") 
]

# Force ANSI coloring on, so Docker doesn't strip it
$env.config.use_ansi_coloring = true
