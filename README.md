# WSL Docker Base

A minimal Ubuntu WSL2 environment managed as Infrastructure as Code, with a Windows-first setup workflow.

## Includes

- Docker Engine

## Setup from Windows

Install WSL and Ubuntu once, if they are not already installed. Open PowerShell as Administrator and run:

```powershell
wsl --install --distribution Ubuntu
```

Restart Windows if prompted. Then clone this repository from PowerShell:

```powershell
git clone https://github.com/<username>/wsl-docker-base.git
cd wsl-docker-base
```

Run the Windows launcher from an already-open PowerShell window. Running the `.ps1` file by double-clicking can close the window before you see an error. It opens Ubuntu WSL2 and runs the Linux setup scripts from the Windows clone; there is no need to clone the repository again inside Ubuntu:

```powershell
.\setup.ps1
```

The launcher automatically restarts WSL so the Docker group membership takes effect, then verifies the installation. To verify again later, run:

```powershell
.\setup.ps1 -VerifyOnly
```

The launcher checks that WSL and the `Ubuntu` distribution are installed and running as WSL2. If either prerequisite is missing, it prints the exact command needed to fix it.

## Direct WSL usage

If you are already working inside Ubuntu, the original shell workflow remains available:

```bash
chmod +x setup.sh verify.sh
./setup.sh
./verify.sh
```
