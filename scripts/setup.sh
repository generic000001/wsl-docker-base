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

    # Add Docker's official GPG key and apt repository, then install.
    # This follows the official Docker docs for Ubuntu and avoids piping to sh,
    # which can trigger advisory pauses in the convenience script.
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    ARCH="$(dpkg --print-architecture)"
    CODENAME="$(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")"
    echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu ${CODENAME} stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -q
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -q \
        docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin
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
