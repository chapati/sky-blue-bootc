* deploy public key to target machines via /etc/containers/policy.json
* generate new keypair protected with password
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
