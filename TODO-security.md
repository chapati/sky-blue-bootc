* harden veracrypt install - check key against official id/fingerprint
* deploy public key to target machines via /etc/containers/policy.json
* generate new keypair protected with password
* run trivy or grype against the image before the signing step failing the job if critical CVEs or unknown binaries are detected
* `cosign attest` to generate and attach an in-toto / SLSA
* enable renovate for cosign
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
