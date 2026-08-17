#!/usr/bin/env bash

set -euo pipefail

is_docker_installed() {
    command -v docker >/dev/null 2>&1 || return 1
    for package in docker-ce docker.io; do
        if dpkg-query -W -f='${db:Status-Status}' "${package}" 2>/dev/null | grep -q '^installed$'; then
            return 0
        fi
    done
    return 1
}

echo "Updating Ubuntu..."
sudo apt-get update -q
sudo apt-get upgrade -y -q

echo "Installing prerequisites..."
sudo apt-get install -y -q ca-certificates curl

if is_docker_installed; then
    echo "Docker is already installed; skipping Docker installation."
else
    echo "Installing Docker..."
    # DEBIAN_FRONTEND suppresses interactive prompts; SKIP_SLEEP avoids the
    # 20-second advisory pause in get.docker.com without patching the script.
    curl -fsSL https://get.docker.com | sudo DEBIAN_FRONTEND=noninteractive SKIP_SLEEP=1 sh
fi

if ! getent group docker >/dev/null 2>&1; then
    echo "Creating the docker group..."
    sudo groupadd docker
fi

if [ "${USER:-}" = "root" ]; then
    echo "Running as root; skipping docker group membership update."
else
    echo "Adding ${USER} to the docker group..."
    sudo usermod -aG docker "${USER}"
fi

echo
echo "Docker installation complete."
echo "Restart WSL before using Docker so the group membership takes effect."
