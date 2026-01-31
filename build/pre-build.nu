use common.nu *

def main [--optfix:path] {
  strict {
    ^mkdir -pv $optfix
  }

  if ("/opt" | path exists) {
    print $"(ansi cyan)Moving all /opt/* into ($optfix)(ansi reset) "
    ^mv -v /opt/* $optfix
    ^rm -frv /opt
  }

  print $"(ansi cyan)Linking /opt => ($optfix)(ansi reset)"
  strict {
    ^ln -fs $optfix /opt
  }
}
