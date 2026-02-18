use common.nu *

def main [--optfix:path] {
    print $"(ansi green)[post-build.nu] started(ansi reset)" 
    
    let optdirs = ls $optfix | where type == dir

    $optdirs | each {
        let dirname = $in.name | path basename
        
        let link = ['/opt' $dirname] | path join
        let real = $in.name
        
        let content = $"L+?  \"($link)\"  -  -  -  -  ($real)"
        let conf_file = $"/usr/lib/tmpfiles.d/99-sky-blue-optfix-($dirname).conf"

        print $"(ansi cyan)Linking(ansi reset) ($real) => ($link)"
        $content | save --force $conf_file
    } | ignore

    print $"(ansi cyan)Cleaning temporary files(ansi reset)"
    strict {
        ^rm -rf /var/cache/*
        ^rm -rf /var/log/*
        ^rm -rf /tmp/*
    }

    strict {
        ^unlink /opt
        ^ln -fs /var/opt /opt
    }

    print $"(ansi green)[post-build.nu] finised(ansi reset)" 
}
