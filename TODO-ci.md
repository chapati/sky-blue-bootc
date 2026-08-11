* enable renovate for cosign

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