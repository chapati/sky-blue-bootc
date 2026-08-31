1. Run local docker registry

N.B. Not that this command makes your local registry visible to the local networks.
It is unsafe to run such service on a public WiFi for example.

```bash
docker run -d -p 0.0.0.0:5000:5000 --restart=always --name local-registry registry:2
```

2. Increase local build cache size

```bash
sudo mkdir -p /etc/buildkit
sudo tee /etc/buildkit/buildkitd.toml > /dev/null <<'EOF'
[worker.oci]
  enabled = true
  gckeepstorage = 80000

  [[worker.oci.gcpolicy]]
    keepBytes = 50000000000
EOF
sudo systemctl restart docker
```

3. Switch to local image.

```bash
export LOCAL_IP=$(ip route show default | awk '{print $3}')

sudo mkdir -p /etc/containers/registries.conf.d && sudo tee /etc/containers/registries.conf.d/sky-blue-dev.conf > /dev/null <<EOF
[[registry]]
location = "${LOCAL_IP}:5000"
insecure = true
EOF

sudo bootc switch ${LOCAL_IP}:5000/sky-blue-nvidia-open:latest
```

4. Swith back to cloud prod image

```bash
sudo bootc switch ghcr.io/chapati/sky-blue-nvidia-open:latest --enforce-container-sigpolicy
```
