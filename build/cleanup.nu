use common.nu strict

def main [] {
    print $"(ansi cyan)[cleanup.nu] cleaning up temporary files(ansi reset)"
    strict {
        rm -rf /var/cache/*
        rm -rf /var/log/*
        rm -rf /tmp/*
    }
}
