1. Run local docker registry

```bash
docker run -d -p 5000:5000 --restart=always --name local-registry registry:2
```

2. Switch to local image.

```bash
export LOCAL_IP=$(ip route show default | awk '{print $3}')

sudo mkdir -p /etc/containers/registries.conf.d && sudo tee /etc/containers/registries.conf.d/sky-blue-dev.conf > /dev/null <<EOF
[[registry]]
location = "${LOCAL_IP}:5000"
insecure = true
EOF

sudo bootc switch ${LOCAL_IP}:5000/sky-blue:latest
```

3. Swith back to cloud prod image

```bash
sudo bootc switch ghcr.io/chapati/sky-blue-nvidia-open:latest --enforce-container-sigpolicy
```
