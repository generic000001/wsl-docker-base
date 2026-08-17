# WSL Docker Base

A minimal Ubuntu WSL2 environment managed as Infrastructure as Code.

## Includes

- Docker Engine

## Prerequisites

- Windows with WSL2 enabled
- An Ubuntu WSL2 distribution

## Setup

Clone the repository:

```bash
git clone https://github.com/<username>/wsl-docker-base.git
cd wsl-docker-base
```

Run the setup script:

```bash
chmod +x setup.sh
./setup.sh
```

Restart WSL from PowerShell so the Docker group membership takes effect:

```powershell
wsl --shutdown
```

Verify the installation:

```bash
./verify.sh
```
