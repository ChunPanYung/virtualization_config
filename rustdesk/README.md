# RustDesk Podman Quadlet

Put `*.container` file into `/etc/containers/systemd/` directory.
It uses local directory `/srv/containers/` for podman volumes.
Make sure to run `bootstrap.bash` to ensure proper firewall rule
and `/srv/containers` directory permissions.
