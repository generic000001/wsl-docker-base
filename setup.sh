#!/usr/bin/env bash

set -euo pipefail

echo "Updating Ubuntu..."
sudo apt-get update
sudo apt-get upgrade -y

echo "Installing prerequisites..."
sudo apt-get install -y ca-certificates curl

echo "Installing Docker..."
curl -fsSL https://get.docker.com | sudo sh

echo "Adding ${USER} to the docker group..."
sudo usermod -aG docker "${USER}"

echo
echo "Docker installation complete."
echo "Restart WSL before using Docker so the group membership takes effect."
