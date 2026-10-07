# dnf

Prevent Reintroduction of Weak Dependencies

```ini
# /etc/dnf/dnf.conf (or /usr/lib/dnf/dnf.conf if supported by your dnf version)
[main]
install_weak_deps=False
```

# docker-ce

Check if feasible: drop docker-ce packages entirely if moving to rootless Podman/Quadlets.
Avoids unmanaged iptables/systemd service conflicts.

# virtmanager

**Use Modular Daemons instead of Monolithic libvirtd**

* Don't enable the legacy libvirtd.service. Modern Fedora/RHEL separates libvirt into isolated modular sockets with least privilege:
  sudo systemctl enable --now virtqemud.socket virtnetworkd.socket virtstoraged.socket

* Ensure sVirt (SELinux Confinement) is Active
  Check that SELinux is enforcing: getenforce. sVirt automatically assigns dynamic, isolated SELinux categories (svirt_t) to every
  running QEMU process so that even if a guest breaks out of QEMU, it remains confined.

* Prefer User-Session VMs When Applicable
  In virt-manager, creating VMs under qemu:///session runs the hypervisor with your regular unprivileged user account instead
  of root (qemu:///system), eliminating host root escalation risk for standard testing VMs.

# openssh-server

**Disable at Boot (Default-Off via Preset)**

Ensure SSH is never enabled out-of-the-box in the image. Let the user explicitly run systemctl enable --now sshd if needed.
Drop a systemd preset into /usr/lib/systemd/system-preset/50-sshd.preset:

```
disable sshd.service
disable sshd.socket
```

**Bake Hardened Configuration via /usr Drop-In**

Use /usr/etc/ssh/sshd_config.d/ or /usr/share/openssh/sshd_config.d/ (Fedora/OpenSSH evaluates /etc/ssh/sshd_config.d/ first,
but drop-ins in /etc/ssh/sshd_config.d/50-hardened.conf can be overridden by users with a 99-user.conf or deleting it in overlay):

```
PermitRootLogin no
PasswordAuthentication no
KbdInteractiveAuthentication no
X11Forwarding no
MaxAuthTries 3
```

# intel-lpmd

Ensure D-Bus configuration in /usr/share/dbus-1/system.d/ only grants state-change rights to root or active console sessions.

# NfsV3 layer with weak security

**If rpcbind is present mask or uninstall**

* systemctl --root / mask rpcbind.service rpcbind.socket

**Enforce NFSv4 Defaults in the Image**

Drop a configuration into /usr/etc/nfs.conf (or /etc/nfs.conf.d/hardening.conf baked into the image) to force NFSv4 and disable legacy fallback:

```ini
[mountd]
manage-gids = y

[nfsd]
vers2 = n
vers3 = n
vers4 = y
vers4.0 = n
vers4.1 = y
vers4.2 = y

[nfsrahead]
nfs = 128
```

**Client Mount Hardening**

* When defining mounts in /etc/fstab, autofs, or systemd mount units, enforce least-privilege options:
vers=4.2,proto=tcp,sec=sys (or sec=krb5p if Kerberos is configured via your krb5-workstation stack).

* Always apply nodev and nosuid. Include noexec on purely data shares.