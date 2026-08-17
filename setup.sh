#!/usr/bin/env bash

set -euo pipefail

echo "Updating Ubuntu..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing prerequisites..."
sudo apt-get install -y ca-certificates curl

docker_package_installed=false
for package in docker-ce docker.io; do
    if dpkg-query -W -f='${db:Status-Status}' "${package}" 2>/dev/null | grep -q '^installed$'; then
        docker_package_installed=true
        break
    fi
done

if command -v docker >/dev/null 2>&1 && [ "${docker_package_installed}" = true ]; then
    echo "Docker is already installed; skipping Docker installation."
else
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com |
        sed -E 's/\([[:space:]]*set -x;[[:space:]]*sleep 20[[:space:]]*\)/:/g' |
        sudo sh
fi

if ! getent group docker >/dev/null 2>&1; then
    echo "Creating the docker group..."
    sudo groupadd docker
fi

if [ "${USER}" = "root" ]; then
    echo "Running as root; skipping docker group membership update."
else
    echo "Adding ${USER} to the docker group..."
    sudo usermod -aG docker "${USER}"
fi

echo
echo "Docker installation complete."
echo "Restart WSL before using Docker so the group membership takes effect."
