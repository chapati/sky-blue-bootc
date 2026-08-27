* create module for curl that checks hash, add hash for zsh gitstatus and other places
* checksums for nerdfonts
* scan third-party repos before embedding into image
* host veracrypt inside the repo
* investigate vs codieum vs vscode (extensions, updates &c)
* analyse packages

```bash
rpm -qa --qf '%{NAME}\n' "python3-*" | sort
dnf repoquery --whatrequires "python3-key*" --installed
```

* get rid of python, as much as possible
* custom dns resolver which blocks access to internal domains from non-hardened browser
* investigate cryptomator vs veracrypt
* harden veracrypt install - check key against official id/fingerprint
* deploy public key to target machines via /etc/containers/policy.json
* generate new keypair protected with password
* run trivy or grype against the image before the signing step failing the job if critical CVEs or unknown binaries are detected
* `cosign attest` to generate and attach an in-toto / SLSA
* enable renovate for cosign
* disable saving passwords in browsers, force bitwarden
* handle tmpfiles through nu module, ensure on boot that all tmpfiles are present otherwise display message / fail &c, support optional linking
```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "customManagers": [
    {
      "customType": "regex",
      "fileMatch": ["^\\.github/workflows/.*\\.yml$"],
      "matchStrings": [
        "ghcr\\.io/sigstore/cosign/cosign:(?<currentValue>v.*?)(?:@(?<currentDigest>sha256:[a-f0-0-9]+))?\\s"
      ],
      "depNameTemplate": "ghcr.io/sigstore/cosign/cosign",
      "datasourceTemplate": "docker"
    }
  ]
}
```

* python removal

```
1. Accessibility & Heavy Input Engines (Saves ~200+ MB)

    orca (Screen reader)

    brltty / python3-brlapi (Braille display support)

    speech-dispatcher-utils / python3-speechd

    ibus-typing-booster, ibus-anthy, zinnia-tomoe-ja (Unused language input predictors)

2. Legacy System & Printing Services

    hplip, hplip-libs, system-config-printer-libs (Replaced by driverless CUPS)

    cockpit-* (Web admin UI)

    firewalld, firewall-config (If switching to native nftables)

    tuned, tuned-ppd (System tuning daemons)

3. Enterprise Storage & Network Protocols (Unless specifically needed)

    glusterfs*, cifs-utils-info, iscsi-initiator-utils*

    samba*, wsdd (Windows file sharing)

    bcache-tools

4. Default Desktop Apps (Best replaced with isolated Flatpaks)

    epiphany-runtime, foliate, clapper, g4music, pinta, qbittorrent, gnome-weather, gnome-calendar

```
